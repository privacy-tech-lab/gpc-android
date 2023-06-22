const gplay = require('google-play-scraper');
const createCsvWriter = require('csv-writer').createObjectCsvWriter;  // install csv-writer package

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
    category: gplay.category.DATING, // change category each time
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

    csvWriter.writeRecords(data)       
    .then(() => {
        console.log('...Done');
    });
});
