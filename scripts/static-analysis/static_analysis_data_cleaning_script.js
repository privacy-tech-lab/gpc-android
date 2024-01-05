const data = require("./static_analysis_info_by_app");
const fs = require("fs");

console.log(data.length);

/*
 * We want to run this function for each index of the list
 */
function map_data_to_simplified_array() {
  let data_copy = data;
  data_copy = data_copy.map(reduce_data);

  return data_copy;
}

/*
 * Function to reduce the value of each key from a list to a json
 * object
 */
function reduce_data(app_data) {
  let temp = {
    application: {
      handle: null,
      version_name: null,
      version_code: null,
      uaid: null,
      name: null,
      permissions: [],
      libraries: [],
    },
    apks: [],
    trackers: [],
  };

  new_data = Object.keys(app_data)[0];
  new_value = app_data[new_data].reduce(reduce_helper, temp);

  return {
    [new_data]: new_value,
  };
}

function reduce_helper(accumulated, current) {
  application = current["application"];
  apk = current["apk"];
  trackers = current["trackers"];

  index = application["handle"];

  /*
   * apks and trackers are going to be lists we can simply append them:
   *
   * apks will be a list of json objects, each object will contain the name
   * of the apk, and its checksum. This will done for all apks in the split-apk,
   * and thus the list.
   *
   * trackers is a list of trackers found in each apk of the split apk. We will
   * combine the lists for all apks in the split apk bundle to get the trackers
   * as app-level data.
   */
  accumulated["trackers"].push(...trackers);
  accumulated_trackers = accumulated["trackers"];

  accumulated["apks"].push(apk);
  accumulated_apks = accumulated["apks"];

  accumulated_application = reduce_application_helper(
    accumulated["application"],
    application,
    index
  );

  return {
    application: accumulated_application,
    apks: accumulated_apks,
    trackers: accumulated_trackers,
  };
}

function reduce_application_helper(
  accumulated_application,
  current_application,
  index
) {
  //handle
  if (accumulated_application["handle"] == null) {
    accumulated_application["handle"] = current_application["handle"];
  } else if (
    accumulated_application["handle"] == current_application["handle"]
  ) {
    //do nothing
  } else {
    console.log("Different handles at index: " + index);
  }

  //version_code
  if (accumulated_application["version_code"] == null) {
    accumulated_application["version_code"] =
      current_application["version_code"];
  } else if (
    accumulated_application["version_code"] ==
    current_application["version_code"]
  ) {
    //do nothing
  } else {
    console.log("Different version_codes at index: " + index);
  }

  //version_name, uaid, name
  if (
    current_application["version_name"] != null &&
    accumulated_application["version_name"] == null
  ) {
    accumulated_application["version_name"] =
      current_application["version_name"];
    accumulated_application["name"] = current_application["name"];
    accumulated_application["uaid"] = current_application["uaid"];
  } else if (
    current_application["version_name"] != null &&
    accumulated_application["version_name"] != null
  ) {
    if (accumulated_application["name"] == null) {
      accumulated_application["name"] = current_application["name"];
    }
  }

  //permissions and libraries
  accumulated_application["permissions"].push(
    ...current_application["permissions"]
  );
  accumulated_application["libraries"].push(
    ...current_application["libraries"]
  );

  return accumulated_application;
}

/*
 * Running the function to get the output.
 */
new_data = map_data_to_simplified_array();

const file = "static_analysis_data_by_app.json";
const jsonData = JSON.stringify(new_data);

fs.writeFile(file, jsonData, (err) => {
  if (err) {
    console.error("Error writing to file: ", err);
  } else {
    console.log("Success!?");
  }
});
