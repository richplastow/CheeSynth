// Generated by CoffeeScript 1.8.0
(function() {
  var Brick, CheeSynth, Claud, Fixture, Test, test,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Brick = (function() {
    Brick.prototype.toString = function() {
      return "[object Brick " + this.id + "]";
    };

    function Brick(opt) {
      this.id = opt.id;
    }

    Brick.prototype.render = function() {
      return ['L--M--R', '|     |', "C " + this.id + " c", '|     |', 'l==m==r'];
    };

    return Brick;

  })();

  CheeSynth = (function() {
    CheeSynth.prototype.toString = function() {
      return '[object CheeSynth]';
    };

    function CheeSynth(opt) {
      if (opt == null) {
        opt = {};
      }
      this.el = opt.el;
      this.width = opt.width;
      this.height = opt.height;
      this.fixtures = [];
    }

    CheeSynth.prototype.add = function(x, y, brick) {
      var fixture;
      this.fixtures.push(fixture = new Fixture({
        id: 'f' + this.fixtures.length,
        x: x,
        y: y,
        brick: brick
      }));
      return fixture;
    };

    CheeSynth.prototype.composit = function() {
      var char, fixture, i, pin, x, y, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
      this.cb = (function() {
        var _i, _ref, _results;
        _results = [];
        for (i = _i = 1, _ref = this.width; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
          _results.push((function() {
            var _j, _ref1, _results1;
            _results1 = [];
            for (i = _j = 1, _ref1 = this.height; 1 <= _ref1 ? _j <= _ref1 : _j >= _ref1; i = 1 <= _ref1 ? ++_j : --_j) {
              _results1.push({});
            }
            return _results1;
          }).call(this));
        }
        return _results;
      }).call(this);
      this.cb.helper = {
        top: {},
        right: [],
        bottom: [],
        left: {}
      };
      _ref = this.fixtures;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        fixture = _ref[_i];
        fixture.composit(this.cb);
      }
      _ref1 = this.cb.helper.bottom;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        pin = _ref1[_j];
        y = pin.y;
        while (this.height > y) {
          char = this.cb.helper.top[pin.x + ',' + y];
          if (char) {
            if (char.p) {
              y = pin.y + 1;
              while (char.y > y) {
                this.cb[pin.x][y] = {
                  c: '|'
                };
                y++;
              }
            }
            break;
          }
          y++;
        }
      }
      _ref2 = this.cb.helper.right;
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        pin = _ref2[_k];
        x = pin.x;
        while (this.width > x) {
          char = this.cb.helper.left[x + ',' + pin.y];
          if (char) {
            if (char.p) {
              x = pin.x + 1;
              while (char.x > x) {
                this.cb[x][pin.y].c = '|' === this.cb[x][pin.y].c ? '+' : '—';
                x++;
              }
            }
            break;
          }
          x++;
        }
      }
    };

    CheeSynth.prototype.render = function() {
      var c, out, x, y, _i, _j, _ref, _ref1;
      this.composit();
      out = '';
      for (y = _i = 0, _ref = this.height - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; y = 0 <= _ref ? ++_i : --_i) {
        for (x = _j = 0, _ref1 = this.width - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; x = 0 <= _ref1 ? ++_j : --_j) {
          c = this.cb[x][y].c;
          out += c ? c : '·';
        }
        out += '\n';
      }
      return this.el.innerHTML = out;
    };

    return CheeSynth;

  })();

  Claud = (function() {
    Claud.prototype.toString = function() {
      return '[object Claud]';
    };

    function Claud(opt) {
      if (opt == null) {
        opt = {};
      }
      this.keydown = __bind(this.keydown, this);
      this.log = new Filog({
        selector: opt.selectors.out,
        console: false
      }).log;
      this["in"] = document.querySelector(opt.selectors["in"]);
      this["in"].setAttribute('contenteditable', 'true');
      this["in"].addEventListener('keydown', this.keydown);
      this.commands = [];
      this.pointer = 0;
    }

    Claud.prototype.add = function(line) {
      this.pointer = (this.commands.push(this.log(line))) - 1;
      return this;
    };

    Claud.prototype.run = function() {
      var e;
      try {
        return eval(this.commands[this.commands.length - 1]);
      } catch (_error) {
        e = _error;
        return this.log(e);
      }
    };

    Claud.prototype.keydown = function(evt) {
      switch (evt.keyCode) {
        case 13:
          this.pointer = (this.commands.push(this.log(this["in"].textContent))) - 1;
          this["in"].innerHTML = '';
          this.run();
          return evt.preventDefault();
        case 38:
          this.pointer = Math.max(0, this.pointer - 1);
          this["in"].innerHTML = this.commands[this.pointer];
          return evt.preventDefault();
        case 40:
          this.pointer = Math.min(this.commands.length - 1, this.pointer + 1);
          this["in"].innerHTML = this.commands[this.pointer];
          return evt.preventDefault();
      }
    };

    return Claud;

  })();

  window.Claud = Claud;

  Fixture = (function() {
    Fixture.prototype.toString = function() {
      return "[object Fixture " + this.id + "]";
    };

    function Fixture(opt) {
      this.id = opt.id;
      this.x = opt.x;
      this.y = opt.y;
      this.brick = opt.brick;
    }

    Fixture.prototype.composit = function(cb) {
      var absX, absY, char, col, isBottom, isLeft, isRight, isTop, line, lines, meta, x, y, _i, _j, _len, _len1, _ref;
      if (0 > this.x || 0 > this.y) {
        throw new Error("" + this + " has -ve position");
      }
      if (!cb[this.x]) {
        throw new Error("" + this + " is beyond x edge");
      }
      if (!cb[this.x][this.y]) {
        throw new Error("" + this + " is beyond y edge");
      }
      lines = this.brick.render();
      for (y = _i = 0, _len = lines.length; _i < _len; y = ++_i) {
        line = lines[y];
        absY = this.y + y;
        if (!cb[this.x][absY]) {
          throw new Error("" + this + " is too tall");
        }
        _ref = line.split('');
        for (x = _j = 0, _len1 = _ref.length; _j < _len1; x = ++_j) {
          char = _ref[x];
          absX = this.x + x;
          col = cb[absX];
          if (!col) {
            throw new Error("" + this + " is too wide");
          }
          if (col[absY].f) {
            throw new Error("" + this + " overlaps " + col[absY].f);
          }
          meta = col[absY] = {
            f: this,
            c: char,
            x: absX,
            y: absY
          };
          isTop = 0 === y;
          isLeft = 0 === x;
          if (!isTop) {
            isBottom = lines.length - 1 === y;
          }
          if (!isLeft) {
            isRight = line.length - 1 === x;
          }
          if (isTop || isRight || isBottom || isLeft) {
            meta.p = /[a-zA-Z]/.test(char);
            if (isTop) {
              cb.helper.top[absX + ',' + absY] = meta;
            }
            if (isLeft) {
              cb.helper.left[absX + ',' + absY] = meta;
            }
            if (meta.p) {
              if (isRight) {
                cb.helper.right.push(meta);
              }
              if (isBottom) {
                cb.helper.bottom.push(meta);
              }
            }
          }
        }
      }
    };

    return Fixture;

  })();

  CheeSynth.Brick = Brick;

  window.CheeSynth = CheeSynth;

  Test = (function() {
    var invisibles, toType;

    Test.prototype.toString = function() {
      return '[object Test]';
    };

    Test.prototype.jobs = [];

    function Test(opt) {
      if (opt == null) {
        opt = {};
      }
      this.run = __bind(this.run, this);
    }

    Test.prototype.run = function() {
      var actual, double, expect, job, md, name, result, runner, summary, tallies, _i, _len, _ref;
      md = [];
      tallies = [0, 0];
      double = null;
      _ref = this.jobs;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        job = _ref[_i];
        switch (toType(job)) {
          case 'function':
            double = job(double);
            break;
          case 'string':
            md.push(job);
            break;
          case 'array':
            runner = job[0], name = job[1], expect = job[2], actual = job[3];
            result = runner(expect, actual, double);
            if (!result) {
              md.push("\u2713 " + name + "  ");
              tallies[0]++;
            } else {
              md.push("\u2718 " + name + "  ");
              md.push("    " + result + "  ");
              tallies[1]++;
            }
        }
        summary = "  passed " + tallies[0] + "/" + (tallies[0] + tallies[1]) + " ";
        summary += tallies[1] ? '\u2718' : '\u2714';
      }
      md.unshift('<a href="#end" id="top">\u2b07</a>' + summary);
      md.push('\n<a href="#top" id="end">\u2b06</a>' + summary);
      return md.join('\n');
    };

    Test.prototype.section = function(text) {
      return this.jobs.push(("\n\n" + text + "\n-") + (new Array(text.length).join('-')) + '\n');
    };

    Test.prototype.custom = function(tests, runner) {
      var i, test, _i, _len;
      for (i = _i = 0, _len = tests.length; _i < _len; i = ++_i) {
        test = tests[i];
        if ('function' === toType(test)) {
          this.jobs.push(test);
        } else {
          this.jobs.push([runner, test, tests[++_i], tests[++_i]]);
        }
      }
      return this.jobs.push('- - -');
    };

    Test.prototype.fail = function(result, delivery, expect, types) {
      if (types) {
        result = "" + (invisibles(result)) + " (" + (toType(result)) + ")";
        expect = "" + (invisibles(expect)) + " (" + (toType(expect)) + ")";
      }
      return "" + (invisibles(result)) + "\n    ...was " + delivery + ", but expected...\n    " + (invisibles(expect));
    };

    invisibles = function(value) {
      return value.toString().replace(/^\s+|\s+$/g, function(match) {
        return '\u00b7' + (new Array(match.length)).join('\u00b7');
      });
    };

    Test.prototype.throws = function(tests) {
      return this.custom(tests, (function(_this) {
        return function(expect, actual, double) {
          var e, error;
          error = false;
          try {
            actual(double);
          } catch (_error) {
            e = _error;
            error = e.message;
          }
          if (!error) {
            return "No exception thrown, expected...\n    " + expect;
          } else if (expect !== error) {
            return _this.fail(error, 'thrown', expect);
          }
        };
      })(this));
    };

    Test.prototype.equal = function(tests) {
      return this.custom(tests, (function(_this) {
        return function(expect, actual, double) {
          var e, error, result;
          error = false;
          try {
            result = actual(double);
          } catch (_error) {
            e = _error;
            error = e.message;
          }
          if (error) {
            return "Unexpected exception...\n    " + error;
          } else if (expect !== result) {
            return _this.fail(result, 'returned', expect, result + '' === expect + '');
          }
        };
      })(this));
    };

    Test.prototype.is = function(tests) {
      return this.custom(tests, (function(_this) {
        return function(expect, actual, double) {
          var e, error, result;
          error = false;
          try {
            result = actual(double);
          } catch (_error) {
            e = _error;
            error = e.message;
          }
          if (error) {
            return "Unexpected exception...\n    " + error;
          } else if (expect !== toType(result)) {
            return _this.fail("type " + (toType(result)), 'returned', "type " + expect);
          }
        };
      })(this));
    };

    toType = function(x) {
      return {}.toString.call(x).match(/\s([a-z|A-Z]+)/)[1].toLowerCase();
    };

    return Test;

  })();

  test = new Test;

  CheeSynth.runTest = test.run;

  test.section("Constructor");

  test.is([
    "Instantiate with no arguments", 'object', function() {
      return new CheeSynth();
    }
  ]);

  test.equal([
    "`toString()` as expected", '[object CheeSynth]', function() {
      return (new CheeSynth()).toString();
    }
  ]);

}).call(this);
