'use strict';

exports.ffiModule = function(name) {
  return function(body) {
    return function() {
      QUnit.module(name, function() {
        body();
      });
    };
  };
};

exports.ffiTest = function(name) {
  return function(body) {
    return function() {
      QUnit.test(name, function(assert) {
        return new Promise(function(resolve, reject) {
          body(function() {
            assert.ok(true);
            resolve();
          }, function(err) {
            reject(err);
          });
        });
      });
    };
  };
};

exports.ffiOnly = function(name) {
  return function(body) {
    return function() {
      QUnit.only(name, function(assert) {
        return new Promise(function(resolve, reject) {
          body(function() {
            assert.ok(true);
            resolve();
          }, function(err) {
            reject(err);
          });
        });
      });
    };
  };
};

exports.ffiSkip = function(name) {
  return function() {
    QUnit.skip(name);
  };
};
