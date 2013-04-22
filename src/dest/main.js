var App, ScrollTo, checkContentPos, clickHandler, currentNav, makeArticle, navs, resizeHandler, scrollToInit, update, wheelHandler, winObj, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

App = (function(_super) {
  __extends(App, _super);

  function App() {
    _ref = App.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  /*
  Kazitori を継承したルーター
  */


  App.prototype.routes = {
    "/": "index",
    "/<int:id>": "show"
  };

  App.prototype.index = function() {
    var $active;

    console.log("index");
    $active = $('.active');
    if ($active.length > 0) {
      return $active.removeClass('active');
    }
  };

  App.prototype.show = function(id) {
    var $active, currentNav;

    console.log("show::" + id);
    $active = $('.active');
    if ($active.length > 0) {
      $active.removeClass('active');
    }
    currentNav = navs[id - 1];
    return $(currentNav).find('a').addClass('active');
  };

  return App;

})(Kazitori);

winObj = {
  WW: window.innerWidth,
  WH: window.innerHeight,
  SC_TOP: 0
};

navs = [];

currentNav = null;

makeArticle = function(WH) {
  return $('.box').each(function(i) {
    $(this).css({
      "height": WH,
      "top": WH * i
    });
    return $(this).find('h1').css({
      "line-height": WH + "px"
    });
  });
};

resizeHandler = function(event) {
  winObj.WH = window.innerHeight;
  makeArticle(winObj.WH);
  return $('#container').css({
    "height": winObj.WH * 10
  });
};

wheelHandler = function(event) {
  return checkContentPos();
};

checkContentPos = function() {
  var pos;

  winObj.SC_TOP = window.scrollY;
  pos = Math.ceil(winObj.SC_TOP / winObj.WH);
  if (window.App.fragment !== pos) {
    return window.App.replace("/" + pos);
  }
};

clickHandler = function(event) {
  var pos;

  event.preventDefault();
  pos = Number($(event.target).attr('href').replace('/', ''));
  window.App.replace('/' + pos);
  return ScrollTo(pos);
};

ScrollTo = function(pos) {
  var position, sctop;

  position = (pos - 1) * winObj.WH + 10;
  position = position < 0 ? 0 : position;
  sctop = window.scrollY;
  return new TWEEN.Tween({
    scrollTop: sctop
  }).to({
    scrollTop: position
  }, 400).easing(TWEEN.Easing.Quartic.Out).onUpdate(function() {
    return window.scroll(0, this.scrollTop);
  }).start();
};

update = function() {
  requestAnimationFrame(update);
  return TWEEN.update();
};

scrollToInit = function(event) {
  var pos;

  window.App.removeEventListener(KazitoriEvent.FIRST_REQUEST, scrollToInit);
  pos = Number(window.App.fragment.replace('/', ''));
  return ScrollTo(pos);
};

$(function() {
  var requestAnimationFrame, win;

  win = window;
  requestAnimationFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame;
  window.requestAnimationFrame = requestAnimationFrame;
  navs = $('#navi').find('li');
  win.App = new App({
    "root": "/"
  });
  win.App.addEventListener(KazitoriEvent.FIRST_REQUEST, scrollToInit);
  $(win).on('resize', resizeHandler);
  $(win).on('mousewheel', wheelHandler);
  $('.tgt').on('click', clickHandler);
  resizeHandler();
  return update();
});
