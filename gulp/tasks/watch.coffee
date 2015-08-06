gulp = require('gulp-help') require 'gulp'
$ = do require 'gulp-load-plugins'
paths = require '../paths'


gulp.task 'reload', false, ->
  do $.livereload.listen
  gulp.watch([
    "#{paths.static.dev}/**/*.{css,js}"
    "#{paths.main}/**/*.{html,py}"
  ], { interval:500 }).on 'change', $.livereload.changed


gulp.task 'ext_watch_rebuild', false, (callback) ->
  $.sequence('clean:dev', 'copy_bower_files', 'ext:dev', 'style:dev') callback


gulp.task 'watch', false, ->
  gulp.watch 'requirements.txt', { interval: 500 }, ['pip']
  gulp.watch 'package.json', { interval: 500 }, ['npm']
  gulp.watch 'bower.json', { interval: 500 }, ['ext_watch_rebuild']
  gulp.watch 'gulp/config.coffee', { interval: 500 }, ['ext:dev', 'style:dev', 'script:dev']
  gulp.watch paths.static.ext, { interval: 500 }, ['ext:dev']
  gulp.watch "#{paths.src.script}/**/*.coffee", { interval: 500 }, ['script:dev']
  gulp.watch "#{paths.src.style}/**/*.less", { interval: 500 }, ['style:dev']
