path = require "path"

gulp = require "gulp"
gutil = require "gulp-util"
stylus = require "gulp-stylus"
coffee = require "gulp-coffee"
csso = require "gulp-csso"
uglify = require "gulp-uglify"
jade = require "gulp-jade"
concat = require "gulp-concat"
livereload = require "gulp-livereload"
symlink = require "gulp-symlink"
clean = require "gulp-clean"

tinylr = require "tiny-lr"
express = require "express"
webpack = require "webpack"
marked = require "marked" # For :markdown filter in jade

app = express()
server = tinylr()

# --- Basic Jobs ---

gulp.task "stylus", ->
  gulp.src "src/**/*.styl"
    .pipe stylus()
    #.pipe(csso())
    .pipe gulp.dest "dist/"
    .pipe livereload(server)

gulp.task "coffee", ->
  gulp.src "src/**/*.coffee"
    .pipe coffee {bare: on}
    .pipe gulp.dest "dist/"
    .pipe livereload(server)

gulp.task "jade", ->
  gulp.src "src/**/*.jade"
    .pipe jade {pretty: on}
    .pipe gulp.dest "dist/"
    .pipe livereload(server)

gulp.task "symlink", ->
  gulp.src "bower_components"
    .pipe symlink("dist/")
 
gulp.task "clean", ->
  gulp.src("dist", {read:false})
    .pipe clean()

gulp.task "express", ->
  app.use require('connect-livereload')()
  app.use express.static(path.resolve("./dist"))
  app.listen 3001
  gutil.log "Listening on port: 3001"

gulp.task "watch", ->
  server.listen 35729, (err) ->
    console.log(err) if err
  gulp.watch "src/**/*.styl", ["stylus", "webpack"]
  gulp.watch "src/**/*.coffee", ["coffee", "webpack"]
  gulp.watch "src/**/*.jade", ["jade", "webpack"]

gulp.task "webpack", ["assets"], ->
  webpackConfig = {
    # cache: on
    entry: "./dist/scripts/main.js"
    output: {
      path: "./dist/"
      filename: "bundle.js"
    }
    resolve: {
      alias:{
        "main.css": "#{__dirname}/dist/styles/main.css"
      }

    }
    # module: {
    #   loaders: [{
    #     test: /\.css$/, loader: "style/useable!css"
    #   }]
    # }
  }

  webpack webpackConfig, (err, stats) ->
    gutil.log "#{err}, #{stats}"

# --- Basic Tasks ---

gulp.task "assets", ["coffee", "stylus", "jade", "symlink"]

# Default Task
gulp.task "default", ["clean"], ->
  gulp.start "assets", "express", "webpack", "watch"

