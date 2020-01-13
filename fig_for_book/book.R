# パッケージ読み込み
library(tidyverse)
library(ggthemes)

## 刀身長の分布
#北海道恵庭市西島松5遺跡出土の奈良時代の刀剣類のデータを使用します。

iron<-read.csv("../data/iron.csv")
＃ 一覧表出力
iron[,c(4:12)] %>% write.csv("iron_head.csv")

# ヒストグラム
p<-iron%>%
	ggplot(aes(x=刀身長))+
	geom_histogram() +
	theme_minimal() +
  theme(axis.title.y = element_blank(),
	  axis.text= element_text(size=5),
#	  axis.text.x=element_text(angle=90),
		legend.title = element_text(size=9),
		legend.text = element_text(size=9),
		axis.title = element_text(size=6),
		plot.title= element_text(size=9),
		strip.text=element_text(size=9),
    panel.grid=element_blank(),
  )	
ggsave("01sword_hist.pdf",p,width=5.8,height=2.8,family="Japan1GothicBBB") 

# 散布図
p <- iron%>%
	ggplot(aes(x=刀身長,y=刀身元幅) )+
	geom_point(size=0.8)+
	theme_minimal() +
  theme(
	  axis.text= element_text(size=5),
#	  axis.text.x=element_text(angle=90),
		legend.title = element_text(size=9),
		legend.text = element_text(size=9),
		axis.title = element_text(size=6),
		plot.title= element_text(size=9),
		strip.text=element_text(size=9),
    panel.grid=element_blank(),
  )	
ggsave("02sword_scat.pdf",p,width=5.8,height=3.6,family="Japan1GothicBBB") 


## ヒストグラム+正規曲線
# 正規曲線作成のための統計量算出
iron%>%
	summarise(mean=mean(刀身長,na.rm=T),sd=sd(刀身長,na.rm=T)) -> s_iron
# 正規曲線作成
x<-seq(0, 60, 0.1)
nom <- x%>%dnorm(mean=s_iron$mean, sd=s_iron$sd)
nom2<-data.frame(X=x,Y=nom)
#正規曲線付きヒストグラム
p <- iron%>%
	ggplot(aes(x=刀身長,y=..density..))+
		geom_histogram()+
		geom_line(data=nom2,aes(x=x,y=Y))+
		scale_colour_ptol()+
		theme_minimal() +
    theme(
    	axis.text= element_text(size=5),
# 	  axis.text.x=element_text(angle=90),
  		legend.title = element_text(size=9),
  		legend.text = element_text(size=9),
  		axis.title.y= element_blank(),
  		axis.title.x = element_text(size=6),
  		plot.title= element_text(size=9),
  		strip.text=element_text(size=9),
     panel.grid=element_blank(),
  )	
ggsave("03sword_hist_norm.pdf",p,width=5.8,height=2.8,family="Japan1GothicBBB") 

# 箱ひげ図を用いた連続量の比較
# ダミーデータ生成
data<-iris
pot<-data[,c(1,2,5)]
colnames(pot)<-c("器高","口径","分類")
pot$分類<-factor(pot$分類,levels=c("setosa","versicolor","virginica"),
	labels=c("A型","B型","C型"))
pot$器高<-pot$器高*7
pot$口径<-pot$口径*10

# ヒストグラム
p <- pot%>%
	ggplot(aes(x=口径,fill=分類))+
		geom_histogram()+
		scale_fill_viridis_d()+
		facet_wrap(~分類,ncol=1,scales="free_y")+
		theme_minimal() +
    theme(
    	axis.text= element_text(size=5),
# 	  axis.text.x=element_text(angle=90),
  		legend.title = element_text(size=9),
  		legend.text = element_text(size=9),  
      legend.position = 'none' ,
  		axis.title.y= element_blank(),
  		axis.title.x = element_text(size=6),
  		plot.title= element_text(size=9),
  		strip.text=element_text(size=6),
     panel.grid=element_blank(),
  )	
ggsave("04pot_hist_facet.pdf",p,width=5.8,height=3.4,family="Japan1GothicBBB") 

## 密度図
p <- pot%>%
	ggplot(aes(x=口径,fill=分類))+
		geom_density(alpha=0.7)+
  	scale_fill_viridis_d() +
		theme_minimal() +
    theme(
    	axis.text= element_text(size=5),
# 	  axis.text.x=element_text(angle=90),
  		legend.title = element_text(size=6),
  		legend.text = element_text(size=6),  
  		axis.title.y= element_blank(),
  		axis.title.x = element_text(size=6),
  		plot.title= element_text(size=9),
  		strip.text=element_text(size=6),
     panel.grid=element_blank(),
  )	
ggsave("05pot_density.pdf",p,width=5.8,height=2.6,family="Japan1GothicBBB") 

## 箱ひげ図
library(ggforce)
p <- pot%>%
	ggplot(aes(x=分類,y=口径,fill=分類))+	
		geom_boxplot(alpha = 0.2)+		#不透明度を0.2
    	geom_sina(aes(colour = 分類),		#geom_sina()関数でaes()の引数にcolour=分類を指定
              alpha = 0.4, 
              size = 1.5) +
		scale_fill_viridis_d() +		#viridis_d(は連続量、離散量ならviridis_c()を指定する
  		scale_colour_viridis_d() +
		coord_flip()+
		theme_minimal() +
    theme(
    	axis.text= element_text(size=5),
# 	  axis.text.x=element_text(angle=90),
  		legend.title = element_text(size=6),
  		legend.text = element_text(size=6),  
  		axis.title.y= element_blank(),
      legend.position = 'none' ,
  		axis.title.x = element_text(size=6),
  		plot.title= element_text(size=9),
  		strip.text=element_text(size=6),
     panel.grid=element_blank(),
  )	
ggsave("06pot_box.pdf",p,width=5.8,height=1.8,family="Japan1GothicBBB") 

## バイオリンプロット
p <- pot%>%
	ggplot(aes(x=分類,y=口径,fill=分類))+	
		geom_violin(scale = "count" , alpha = 0.2,trim = FALSE)+		#不透明度を0.2 面積を実数に比例、端をなめらかに処理
    	geom_sina(aes(colour = 分類),		#geom_sina()関数でaes()の引数にcolour=分類を指定
              alpha = 0.4, 
              size = 1.5) +
		scale_fill_viridis_d() +		#viridis_d(は連続量、離散量ならviridis_c()を指定する
  		scale_colour_viridis_d() +
		coord_flip()+
		theme_minimal() +
    theme(
    	axis.text= element_text(size=5),
# 	  axis.text.x=element_text(angle=90),
  		legend.title = element_text(size=6),
  		legend.text = element_text(size=6), 
       legend.position = 'none' ,
  		axis.title.y= element_blank(),
  		axis.title.x = element_text(size=6),
  		plot.title= element_text(size=9),
  		strip.text=element_text(size=6),
     panel.grid=element_blank(),
  )	
ggsave("07pot_violin.pdf",p,width=5.8,height=2.5,family="Japan1GothicBBB") 


## 多重比較による差の検定〜
# aov関数の結果をanova関数に渡します。
# aov関数の第一引数は連続量~離散量
aov(口径~分類,data=pot)%>% anova()%>%kable(format="markdown")
# TukeyHSD関数で多重比較
tkh <- 
	aov(口径 ~ 分類, data = pot) %>% 
	TukeyHSD() %>% 
	.$分類 %>%	#TukeyHSD関数の結果から$分類を選択 
	as_tibble() %>% 	#tibble_df形式に変換
	mutate_if(is.numeric, round,3)		#mutate_if()でnumericクラスのカラムにround関数を適用する。
tkh%>%kable(format="markdown")

# 円グラフ
# データ読み込み
toj<-read.csv("../data/pot.csv")
# データの順序定義
toj$器種<-toj$器種%>%
	factor(levels=c("碗","皿","その他食膳具","壺･甕･瓶",
		"土瓶","鍋","すり鉢","灯明皿・油注","その他"))
# 円グラフは使わない
toj_pie <- toj %>% 
  group_by(器種) %>%
  summarise(点数=sum(点数))
pdf("08pie.pdf" )
par(family = "Japan1GothicBBB" , ps=7)
pie(toj_pie$点数,labels=toj_pie$器種)
dev.off()

なお、Rで円グラフ（Pie charts）のヘルプを表示すると次のように記載されています。

Note:

     Pie charts are a very bad way of displaying information.  The eye
     is good at judging linear measures and bad at judging relative
     areas.  A bar chart or dot chart is a preferable way of displaying
     this type of data.

     Cleveland (1985), page 264: “Data that can be shown by pie charts
     always can be shown by a dot chart.  This means that judgements of
     position along a common scale can be made instead of the less
     accurate angle judgements.” This statement is based on the
     empirical investigations of Cleveland and McGill as well as
     investigations by perceptual psychologists.

意訳

円グラフは不適切な可視化手法です。人間の目は直線的な形状の判断には優れていますが、面の比較は苦手です。円グラフで表現できるデータは棒グラフやドットチャートで表現するべきです。

「円グラフで表示できるデータは全てドットチャートで表現できます。円の内角による不正確な判断ではなく、誰もが判断できるモノサシを用いるべきであることを意味しています」（Cleveland 1985,p264）

## 構成比棒グラフ_カラー
p <- toj%>%
	ggplot(aes(x=遺跡名,y=点数,fill=器種))+
		geom_bar(stat="identity",position="fill")+
		coord_flip()+
		scale_fill_viridis_d(
      guide = guide_legend(
        keywidth = 1.2, keyheight = 0.8)
    ) +
		theme_minimal() +
    theme(
    	axis.text= element_text(size=5),
# 	  axis.text.x=element_text(angle=90),
  		legend.title = element_text(size=6),
  		legend.text = element_text(size=6), 
  		axis.title= element_blank(),
  		plot.title= element_text(size=9),
  		strip.text=element_text(size=6),
     panel.grid=element_blank()
  )	
ggsave("08pot_bar_colour.pdf",p,width=5.8,height=2,family="Japan1GothicBBB") 


## 構成比棒グラフ＿モノクロ
p <- toj%>%
  ggplot(aes(x=遺跡名,y=点数,fill=器種))+
    geom_bar(stat="identity",position="fill", colour="Grey")+
		coord_flip()+
		scale_fill_brewer(
      palette="Greys", 
      guide = guide_legend(
        keywidth = 1.2, keyheight = 0.8
      )
     )+
		theme_minimal() +
    theme(
    	axis.text= element_text(size=5),
# 	  axis.text.x=element_text(angle=90),
  		legend.title = element_text(size=6),
  		legend.text = element_text(size=6), 
  		axis.title= element_blank(),
  		plot.title= element_text(size=9),
  		strip.text=element_text(size=6),
     panel.grid=element_blank()
  )	
ggsave("09pot_bar_bw.pdf",p,width=5.8,height=2,family="Japan1GothicBBB") 

### 解決法1　カテゴリーを減らす
# 食膳具、貯蔵具、その他に区分
toj2<-toj%>%
	mutate(
		大別器種 = case_when(
			str_detect(器種,"碗|皿|その他食膳具") ~ "食膳具",
			str_detect(器種,"壺･甕･瓶") ~ "貯蔵具",
			str_detect(器種,"灯明皿・油注|その他|すり鉢|鍋|土瓶") ~ "その他",
		)
	)
# 3区分の構成比棒グラフ
p <- toj2%>%
	ggplot(aes(x=遺跡名,y=点数,fill=大別器種))+
		geom_bar(stat="identity",position="fill")+
		coord_flip()+
		scale_fill_brewer(palette="Greys")+
		theme_minimal() +
    theme(
    	axis.text= element_text(size=5),
# 	  axis.text.x=element_text(angle=90),
  		legend.title = element_text(size=6),
  		legend.text = element_text(size=6), 
  		axis.title= element_blank(),
  		plot.title= element_text(size=9),
  		strip.text=element_text(size=6),
     panel.grid=element_blank()
  )	
ggsave("10pot_bar_bw_3cat.pdf",p,width=5.8,height=2,family="Japan1GothicBBB") 


### 解決法2　ファセットされた棒グラフを使う
p <- toj%>%
	ggplot(aes(x=器種,y=点数))+
	geom_bar(stat="identity")+
	coord_flip()+
  facet_wrap(~遺跡名,scales="free")+
	theme_minimal() +
    theme(
    	axis.text= element_text(size=5),
# 	  axis.text.x=element_text(angle=90),
  		legend.title = element_text(size=6),
  		legend.text = element_text(size=6), 
  		axis.title= element_blank(),
  		plot.title= element_text(size=9),
  		strip.text=element_text(size=6),
     panel.grid=element_blank()
  )	
ggsave("11pot_bar_bw_facet.pdf",p,width=5.8,height=2.6,family="Japan1GothicBBB") 

# 散布図で2変量の関係を可視化する
library(PerformanceAnalytics)
pdf("12pair.pdf")
par(family = "Japan1GothicBBB")
iron %>%
	select(全長, 刀身長, 茎長, 刀身先幅, 刀身元幅, 刀身元厚, 茎先幅) %>%
		chart.Correlation(histogram = TRUE, pch = 19)
dev.off()

## 回帰線つき散布図
library(ggpmisc)
p <- iron %>%
	ggplot(aes(x=刀身元幅,y=刀身長))+
		geom_point(size= 0.8)+
		geom_smooth(method="lm" , size = 0.5)+
		theme_minimal() +
		stat_poly_eq(formula = y ~ x, size =2.5 ,
			eq.with.lhs = "italic(hat(y))~`=`~",
			aes(label = paste(stat(eq.label), 
				stat(rr.label), 
				sep = "~~~")
			), parse = TRUE
		) +
		stat_fit_glance(label.y = 0.89, size=2.5,
			method = "lm",
			method.args = list(formula = y ~ x),
			aes(label = sprintf(
				'~~italic(P)~"="~~%.25f',
				stat(p.value)
				)
			),parse = TRUE
		) +
    theme(
    	axis.text= element_text(size=5),
# 	  axis.text.x=element_text(angle=90),
  		legend.title = element_text(size=6),
  		legend.text = element_text(size=6), 
  		axis.title= element_blank(),
  		plot.title= element_text(size=9),
  		strip.text=element_text(size=6),
     panel.grid=element_blank()
  )	
ggsave("13scat_lm.pdf",p,width=5.8,height=3.6,family="Japan1GothicBBB") 


```{r echo=FALSE,eval=FALSE}
# LaTeX
render("README.Rmd")
https://github.com/IshiiJunpei/2019datasience.git
```


<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="クリエイティブ・コモンズ・ライセンス" style="border-width:0" src="fig/ccby.png" width="100" /></a><br />この 記事 は <a rel="license" href="http://creativecommons.org/licenses/by/4.df0/">クリエイティブ・コモンズ 表示 4.0 国際 ライセンスの下に提供されています。</a>



