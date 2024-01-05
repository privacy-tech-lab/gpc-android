const data = require("./static_analysis_data_by_app");
const fs = require("fs");

/*
 * Function to extract permission data.
 */
function extract_permissions() {
  const permissions_data = data.map((app) => {
    app_name = Object.keys(app)[0];
    app_data = app[app_name];

    app_permissions = app_data["application"]["permissions"];
    return {
      [app_name]: app_permissions,
    };
  });

  return permissions_data;
}

/*
 * Function to extract tracker data.
 */
function extract_trackers() {
  const trackers_data = data.map((app) => {
    app_name = Object.keys(app)[0];
    app_data = app[app_name];

    app_trackers = app_data["trackers"];
    return {
      [app_name]: app_trackers,
    };
  });

  return trackers_data;
}

/*
 * Run both the functions
 */

permissions_data = extract_permissions();

const file = "static_analysis_permissions_by_app.json";
const jsonData = JSON.stringify(permissions_data);

fs.writeFile(file, jsonData, (err) => {
  if (err) {
    console.error("Error writing to file: ", err);
  } else {
    console.log("Success 1.");
  }
});

trackers_data = extract_trackers();

const file_2 = "static_analysis_trackers_by_app.json";
const jsonData_2 = JSON.stringify(trackers_data);

fs.writeFile(file_2, jsonData_2, (err) => {
  if (err) {
    console.error("Error writing to file: ", err);
  } else {
    console.log("Success 2.");
  }
});
