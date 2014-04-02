path = require "path"

gulp = require "gulp"
gutil = require "gulp-util"
stylus = require "gulp-stylus"
coffee = require "gulp-coffee"
#csso = require "gulp-csso"
#uglify = require "gulp-uglify"
jade = require "gulp-jade"
#concat = require "gulp-concat"
livereload = require "gulp-livereload"
symlink = require "gulp-symlink"
clean = require "gulp-clean"
watch = require "gulp-watch"
plumber = require "gulp-plumber"

es = require "event-stream"

tinylr = require "tiny-lr"
express = require "express"
webpack = require "webpack"
#marked = require "marked" # For :markdown filter in jade

app = express()

# must change the node_modules/tiny-lr/lib/client.js file 
# replace LiveCss to liveCSS.
# contribute back this simple bug fix.
serverLR = tinylr({
  liveCSS: off
  liveJs: off
  LiveImg: off
  })

# --- Utilities ---

combo = (tasks) -> gutil.combine.apply(gutil, tasks)()

through = (fn) ->
  es.through (file, cb) ->
    fn.call @, file

createTask = (cfg, tasks) ->
  gulp.src cfg.src
    .pipe combo tasks 
    .pipe gulp.dest cfg.dest

createWatcher = (cfg, tasks)->
  createTask cfg, [
    watch()
    plumber()
    combo tasks
    livereload(serverLR)
    webpackTask
  ]

webpackTask = do ->
  cfg = {
    entry: "./dist/scripts/main.js"
    output: {
      path: "./dist/"
      filename: "bundle.js"
    }
  }

  through (file) ->
    webpack cfg, (err, stats) =>
      gutil.log "#{err}, #{stats}"
      @emit "data", file


# --- Individual Tasks ---

gulp.task "stylus", -> 
  createWatcher {src: ["src/**/*.styl", "!src/libs/**/*"], dest: "dist/"}, [
    stylus()
  ]

gulp.task "coffee", -> 
  createWatcher {src: "src/**/*.coffee", dest: "dist/"}, [
    coffee {bare: on}
  ]

gulp.task "jade", -> 
  createWatcher {src: "src/**/*.jade", dest: "dist/"}, [
    jade {pretty: on}
  ]

gulp.task "symlink", ->
  gulp.src "bower_components"
    .pipe symlink("dist/")
 
gulp.task "clean", ->
  gulp.src("dist", {read:false})
    .pipe clean()

# --- Combined Tasks ---

gulp.task "assets", ["clean"], ->
  gulp.start "coffee", "stylus", "jade", "symlink"


gulp.task "express", ["assets"], ->
  app.use require('connect-livereload')()
  app.use express.static(path.resolve("./dist"))
  app.listen 3001
  gutil.log "Listening on port: 3001"

# --- Default Task ---

gulp.task "default", ->
  serverLR.listen 35729, (err) ->
    console.log "err" if err
    gulp.start "express"

