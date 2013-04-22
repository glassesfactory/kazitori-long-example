class App extends Kazitori
    ###
    Kazitori を継承したルーター
    ###
    routes:
        "/": "index"
        "/<int:id>": "show"

    index:()->
        #インデックスへのアクセス
        console.log "index"
        $active = $('.active')
        if $active.length > 0
            $active.removeClass('active')

    show:(id)->
        #下層へのアクセス
        console.log "show::" + id
        #ナビゲーションの変更
        $active = $('.active')
        if $active.length > 0
            $active.removeClass('active')
        currentNav = navs[id - 1]
        $(currentNav).find('a').addClass('active')

#ウィンドウ情報を格納するオブジェクト
winObj = 
    WW: window.innerWidth
    WH: window.innerHeight
    SC_TOP: 0

navs = []
currentNav = null

makeArticle =(WH)->
    #コンテンツのリサイズ
    $('.box').each((i)->
        $(@).css
            "height": WH
            "top": WH * i
        $(@).find('h1').css
            "line-height": WH + "px"
    )

resizeHandler =(event)->
    #ウィンドウがリサイズされた時の処理
    winObj.WH = window.innerHeight
    makeArticle(winObj.WH)
    $('#container').css
        "height": winObj.WH * 10

wheelHandler =(event)->
    #マウスホイールコロコロ
    checkContentPos()

checkContentPos =()->
    #現在のスクロール位置からコンテンツに該当する URLに変更
    winObj.SC_TOP = window.scrollY
    pos = Math.ceil(winObj.SC_TOP / winObj.WH)
    if window.App.fragment isnt pos
        window.App.replace("/" + pos)

clickHandler =(event)->
    #ナビゲーションをクリックされた
    event.preventDefault()
    #ナビゲーションの href から URL を Kazitori 向けにパース
    pos = Number($(event.target).attr('href').replace('/', ''))
    window.App.replace('/' + pos)
    #スクロールさせる
    ScrollTo(pos)

ScrollTo =(pos)->
    #ウィンドウをスクロールさせる
    #ポジションを計算
    position = (pos - 1) * winObj.WH + 10
    #ネガティブスクロールを 0 に
    position = if position < 0 then 0 else position
    sctop = window.scrollY
    
    #Tween24.js ﾏﾀﾞｧ?(・∀・ )っ/凵⌒☆ﾁﾝﾁﾝ
    new TWEEN.Tween({scrollTop:sctop})
    .to({scrollTop:position}, 400)
    .easing(TWEEN.Easing.Quartic.Out)
    .onUpdate(()->
        window.scroll(0, @.scrollTop)
    ).start()

update =()->
    #Tween アニメーションをループさせる
    requestAnimationFrame(update)
    TWEEN.update()

scrollToInit =(event)->
    #URL バーから直接下層にアクセスされた時の処理
    window.App.removeEventListener KazitoriEvent.FIRST_REQUEST, scrollToInit
    pos = Number(window.App.fragment.replace('/', ''))
    ScrollTo(pos)

$(()->
    win = window
    requestAnimationFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame
    window.requestAnimationFrame = requestAnimationFrame

    navs = $('#navi').find('li')
    win.App = new App({"root": "/"})
    win.App.addEventListener KazitoriEvent.FIRST_REQUEST, scrollToInit
    $(win).on 'resize', resizeHandler
    $(win).on 'mousewheel', wheelHandler
    $('.tgt').on 'click', clickHandler
    resizeHandler()
    update()
)
