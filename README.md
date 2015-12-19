## AdventCalendar 2015

AdventCalendar 2015で書いた記事のサンプルなどをまとめたレポジトリです。

追加したらREADMEにも追記していきます。

## プロジェクト一覧

AdventCalendar2015の記事に合わせて作ったサンプル等の説明です

### [SampleLocalNotification](https://github.com/ryokosuge/AdventCalendar2015/tree/master/SampleLocalNotification)

LocalNotificationの実装サンプルです。

適当にManagerクラスを作成して、イベントに合わせて設定したり起動時にLocalNotificationをキャンセルしたりってやってます。

### [SampleSmartNewsUI](https://github.com/ryokosuge/AdventCalendar2015/tree/master/SampleSmartNewsUI)

SmartNewsみたいなUIを実現してみました。

`UIViewControlelr`と`UIPageViewController`を使って全体的に実装されています。

### [SampleInfinityCollectionView](https://github.com/ryokosuge/AdventCalendar2015/tree/master/SampleInfinityCollectionView)

無限スクロールできる`UICollectionView`を実装してみました。

### [SampleSFSafariViewController](https://github.com/ryokosuge/AdventCalendar2015/tree/master/SampleSFSafariViewController)

`UINavigationController`のpush / popのアニメーションで`SFSafariViewController`を表示できるように実装してみました。

### [SampleSwipeNavigationController](https://github.com/ryokosuge/AdventCalendar2015/tree/master/SampleSwipeNavigationController)

`UINavigationController`を横スワイプで戻れるようにしてみた

### [SampleMMMarkdown](https://github.com/ryokosuge/AdventCalendar2015/tree/master/SampleMMMarkdown)

Markdownを描画するライブラリを使用してQiitaの記事を表示してみました。

## 書いた記事

- 12/03 [【iOS】配列の要素をユニークにしてみる](http://qiita.com/ryokosuge/items/39bc83465e2ac9a003f2)

	iOSのAdventCalendarなのに**Swift**のことを書きました。
	
	`SequenceType`など色々調べて自分にとっても勉強になりました。
	
- 12/10 [【iOS】LocalNotification使ってユーザーの復帰率を上げよう！](http://qiita.com/ryokosuge/items/cbc9ce335c7a3f60243a)

	LocalNotificationの実装について書きました。
	
- 12/12 [【iOS】SmartNewsみたいなUIをつくってみました](http://qiita.com/ryokosuge/items/4603c3072de21eb4da03)

	SmartNewsみたいなHeaderの部分のUIを真似てみました。
	
- 12/13 [【iOS】無限スクロールするUICollectionViewの作り方](https://github.com/ryokosuge/AdventCalendar2015/tree/master/SampleInfinityCollectionView)

	ひたすらスクロールできるUICollectionViewを作りました。

- 12/15 [【iOS】SFSafariViewControllerをPush / Pop のアニメーションで表示する](https://github.com/ryokosuge/AdventCalendar2015/tree/master/SampleSFSafariViewController)

	Model表示しかできないSFSafariViewControllerにpush / popのアニメーションで表示するサンプル作りました。
	
- 12/19 [【iOS】Swipeで簡単に戻れるNavigationControllerを作ってみた](http://qiita.com/ryokosuge/items/e3cee04cf8ff0c138719)

	`UINavigationController`で横スワイプに対応させる実装方法を書きました。

- 12/20 [【iOS】MarkdownをHTMLにレンダリングするライブラリを使って、Qiitaの記事をMarkdownで表示してみた](http://qiita.com/ryokosuge/items/64bb6df23fbf98325c5c)

	`MMMarkdown`を使用する方法を書きました。
