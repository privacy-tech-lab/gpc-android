const gplay = require('google-play-scraper');
const createCsvWriter = require('csv-writer').createObjectCsvWriter;  // you need to install csv-writer package

// Define the game categories
const categories = [
  'GAME_ACTION',
  'GAME_ADVENTURE',
  'GAME_ARCADE',
  'GAME_BOARD',
  'GAME_CARD',
  'GAME_CASINO',
  'GAME_CASUAL',
  'GAME_EDUCATIONAL',
  'GAME_MUSIC',
  'GAME_PUZZLE',
  'GAME_RACING',
  'GAME_ROLE_PLAYING',
  'GAME_SIMULATION',
  'GAME_SPORTS',
  'GAME_STRATEGY',
  'GAME_TRIVIA',
  'GAME_WORD',
  'ART_AND_DESIGN',
  'AUTO_AND_VEHICLES',
  'BEAUTY',
  'BOOKS_AND_REFERENCE',
  'BUSINESS',
  'COMICS',
  'COMMUNICATION',
  'DATING',
  'EDUCATION',
  'ENTERTAINMENT',
  'EVENTS',
  'FINANCE',
  'FOOD_AND_DRINK',
  'HEALTH_AND_FITNESS',
  'HOUSE_AND_HOME',
  'LIBRARIES_AND_DEMO',
  'LIFESTYLE',
  'MAPS_AND_NAVIGATION',
  'MEDICAL',
  'MUSIC_AND_AUDIO',
  'NEWS_AND_MAGAZINES',
  'PARENTING',
  'PERSONALIZATION',
  'PHOTOGRAPHY',
  'PRODUCTIVITY',
  'SHOPPING',
  'SOCIAL',
  'SPORTS',
  'TOOLS',
  'TRAVEL_AND_LOCAL',
  'VIDEO_PLAYERS',
  'WEATHER'
];

// Function to scrape apps for a given category
async function scrapeApps(category) {
  const csvWriter = createCsvWriter({
    path: `apps-${category}.csv`, // Change the path and filename as needed
    header: [
      { id: 'appId', title: 'APP_ID' },
      { id: 'title', title: 'TITLE' },
      { id: 'developer', title: 'DEVELOPER' },
      { id: 'score', title: 'SCORE' },
    ],
  });

  try {
    const apps = await gplay.list({
      category: category,
      collection: gplay.collection.TOP_FREE,
      num: 40
    });

    const data = apps.map(app => {
      return {
        appId: app.appId,
        title: app.title,
        developer: app.developer,
        score: app.score
      };
    });

    await csvWriter.writeRecords(data);
    console.log(`Apps for category '${category}' scraped successfully.`);
  } catch (error) {
    console.error(`Error scraping apps for category '${category}':`, error);
  }
}

// Iterate over the categories and scrape apps
async function scrapeAppsForAllCategories() {
  for (const category of categories) {
    await scrapeApps(category);
  }
}

scrapeAppsForAllCategories();
