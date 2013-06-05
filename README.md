# Green Buildings App

## Setup
Clone the repo and then install Yeoman and dependencies

    npm install -g yo grunt-cli bower

Install application dependencies

    npm install bower && bower install

Use Grunt for building, testing and serving

    grunt build
    grunt test
    grunt server

## CSS Assets
You'll notice that some of the css files for leaflet don't get includeded with this. This is a limitation of Sass being unable to import plain css files in its current form.
Set up symlinks in your `app/styles` directory to these assets and you're off to the races as such:

    cd app/styles && ln -s ../components/leaflet/dist/leaflet.css _leaflet.scss

## Phonegap build
Both the xcode and eclipse projects are present in the repo. To build and test, you must run the following:

    grunt phonegap

    # iOS
    cp www/scripts/config.js ios/www/scripts/config.js
    cp www/styles/main.css ios/www/styles/main.css

    # Android
    cp www/scripts/config.js android/assets/www/scripts/config.js
    cp www/styles/main.css android/assets/www/styles/main.css
