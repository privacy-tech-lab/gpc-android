const gplay = require('google-play-scraper');
const createCsvWriter = require('csv-writer').createObjectCsvWriter;  // you need to install csv-writer package

const csvWriter = createCsvWriter({
    path: 'dating-apps.csv', // change path each time
    header: [
        {id: 'appId', title: 'APP_ID'},
        {id: 'title', title: 'TITLE'},
        {id: 'developer', title: 'DEVELOPER'},
        {id: 'score', title: 'SCORE'},
    ],
});

gplay.list({
    category: gplay.category.DATING,
    collection: gplay.collection.TOP_FREE,
    num: 50
})
.then((apps) => {
    let data = apps.map(app => {
        return {
            appId: app.appId,
            title: app.title,
            developer: app.developer,
            score: app.score
        };
    });

    csvWriter.writeRecords(data)       // returns a promise
    .then(() => {
        console.log('...Done');
    });
});
