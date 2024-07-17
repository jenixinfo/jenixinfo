<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<style>
.sbchart-axis-x .tick text{
	font-family: "Noto Sans KR";
	color: var(--color-black2);
	font-size:1.5rem;
}

@media(max-width: 480px) {
	.sbchart-axis-x .tick text{
		font-size:1.0rem;
	}
}
</style>
<script type="text/javascript">
var tabJsonData4 = [
	{ "id": "0", "pid": "-1", "order": "1", "text": "최근 본 상품", "targetid": "SBUx_JS2_JSON3", "targetvalue": "SBUX22 탭" },
	{ "id": "1", "pid": "-1", "order": "2", "text": "주취급 품목 상품", "targetid": "SBUx_JS3_JSON3", "targetvalue": "SBUX22 2탭" },
	{ "id": "2", "pid": "-1", "order": "3", "text": "관심 상품", "targetid": "SBUx_JS4_JSON3", "targetvalue": "SBUX22 3탭" },
];
/*
 * 상위 거래품목 도넛차트 생성
 */
scwin.fnDrawDonutChat = (list) => {
	var dataList = [];
	
	if(list != null && list.length > 0){
		list.forEach(item => {
			dataList.push([item.mclsNm, item.tone])
		});
	} 
	
	sb.chart.render("#chart-donut", {
		global: {
			padding: {
				bottom: 10
			},
			color: {
				pattern: ['#6CAAF9', '#59DEBD', '#48D468', '#FFDD68', '#935AE7', '#FF8165'],
			},
		},

		data: {
			type: "donut"
			, columns: dataList
			, noData : "데이터가 없습니다."
		},
		legend: {
			show: false,
		}
	});
}

/*
 * 최근 실적 콤보 차트 생성
 */
scwin.fnDrawComboChat = (list) => {
	var jsonStr = JSON.stringify(list);
	jsonStr = jsonStr.replaceAll("tone", "물량");
	jsonStr = jsonStr.replaceAll("amt", "금액");
	
	sb.chart.render("#chart-combi", {
		global: {
			color: {
				pattern: ['#17BF56', '#F33F5E'],
			},
		},
		data: {
			types: { "물량": "bar", "금액": "line" },
			json: JSON.parse(jsonStr),
			keys: {
				x: "weekNm",
				value: ["물량", "금액",]
			}
			, noData : "데이터가 없습니다."
		},
		axis: {
			x: {
				tick: {
					outer: false,
					line: false
				},
				type: 'category',
			}
			, axes: { y: ["물량"], y2:["금액"] }
			, y : {
				show : false
				, zerobased: true
			}
			, y2 : {
				show : false
				, zerobased: true
			}
		},
		grid: {
			x: {
				show: false
			},
			y: {
				show: true
			}
		},
		extend: {
			point: {
				r: 5
			}
		},
		legend: {
			show: false,
			padding: 25,
		},
		tooltip: {
			format: {
				value: function(value, ratio, id, index, value2){
					var result = common.mask.money(value.toString())
					if(id == '물량'){
						result += "t"
					}else if(id == '금액'){
						result += "만원"
					}
					
					return result;
				}
			}
		}
	});
}

/*
 * 주문배송 더보기
 */
scwin.fnGoOrdrDlvyList = () => {
	common.net.setHrefData("/client/om/ordrdl/ordrDlListPage.do", {});
}

/*
 * 관심 상품 더 보기 
 */
scwin.fnGoInrstPrdctList = (param) => {
	if(param == '001'){
		//관심 상품
		common.net.setHrefData("/client/mp/myp/itrstGdsList.do", {});
	}else if (param == '002'){
		//최근 본 상품
		common.net.setHrefData("/client/mp/myp/recentViewGdsList.do", {});
	}else if (param == '004'){
		//관심 품목
		common.net.setHrefData("/client/mp/myp/itrstGdsList.do", {});
	}
}

scwin.fnGetDmList = (selectId, selectJson) => {
	if(selectId == "SBUx_IDE_JSON3"){
		var len = $("#item_list02").children().length;
		
		if(len != null && len == 0){
			scwin.fnGetBid01();
		}
	}else if(selectId == "SBUx_IDE1_JSON3"){
		var len = $("#item_list03").children().length;
		
		if(len != null && len == 0){
			scwin.fnGetBid02();
		}
	}
}

/*
 * 정가거래 목록 생성
 */
scwin.fnGetNtprc = () => {
	var param = {
		"rownum" : 10
		, "trnsWayCd" : "001"
		, "type" : "ntprc"
	}
	
	scwin.fnGetPrdctList(param);
}
/*
 * 입찰거래 목록 조회
 */
scwin.fnGetBid01 = () => {
	var param = {
		"rownum" : 10
		, "trnsWayCd" : "002"
		, "type" : "bid01"
	}
	
	scwin.fnGetPrdctList(param);
}

/*
 * 역경매 목록 조회
 */
scwin.fnGetBid02 = () => {
	var param = {
		"rownum" : 10
		, "trnsWayCd" : "003"
		, "type" : "bid02"
	}
	
	scwin.fnGetPrdctList(param);
}

scwin.fnGetIntrst = (selectId, selectJson) => {
	if(selectId == "SBUx_JS3_JSON3"){
		var len = $("#item_list_intrst004").children().length;
		
		if(len != null && len == 0){
			scwin.fnGetIntrst004();
		}
	}else if(selectId == "SBUx_JS4_JSON3"){
		var len = $("#item_list_intrst001").children().length;
		
		if(len != null && len == 0){
			scwin.fnGetIntrst001();
		}
	}
}

/*
 * 관심 상품 목록 조회
 */
scwin.fnGetIntrst001 = () => {
	var param = {
		"rownum" : 5
		, "type" : "intrst001"
		, "intrstPrdctDvCd" : "001"
	}
	scwin.fnGetPrdctList(param);
}

/*
 * 최근 본 상품 목록 조회
 */
scwin.fnGetIntrst002 = () => {
	
	
	var param = {
		"rownum" : 5
		, "type" : "intrst002"
		, "intrstPrdctDvCd" : "002"
	}
	scwin.fnGetPrdctList(param);
}

/*
 * 관심 품목 목록 조회
 */
scwin.fnGetIntrst004 = () => {
	var param = {
		"rownum" : 5
		, "type" : "intrst004"
		, "intrstPrdctDvCd" : "004"
	}
	scwin.fnGetPrdctList(param);
}

/*
 * 상품 정보 조회
 */
scwin.fnGetPrdctList = (param) => {
	let jsonData = {};
	jsonData["action"] = "/api/client/mn/main/selectListDm.do";
	jsonData["reqDoc"] = param
	let promise = common.promise.ajax(jsonData, "", false);
	promise = promise.then((o)=> {
		if (o) {
			if (o.statusCode===`S`) {
				var list = o.resultData.list;
				
				switch (param.type){
					case "ntprc" : 
						scwin.fnMakeDmItem(list, "item_list01");
						break;
					case "bid01" :
						scwin.fnMakeDmItem(list, "item_list02");
						break;
					case "bid02" :
						scwin.fnMakeDmItem(list, "item_list03");
						break;
					case "intrst001" :
						scwin.fnMakeIntrst(list, "item_list_intrst001");
						break;
					case "intrst002" :
						scwin.fnMakeIntrst(list, "item_list_intrst002");
						break;
					case "intrst004" :
						scwin.fnMakeIntrst(list, "item_list_intrst004");
						break;
				}
			}
		}
	});
}

//관심상품 등록,해제
scwin.fnLike = (trnsWayCd, trnsId, prdctDetlId,target) => {
	if(!common.isEmpty(scvar.firmTypeCd)){
		let jsonData = {};
		jsonData["action"] = "/api/client/us/srch/updatePrchrIntrstInfo.do";
		jsonData["reqDoc"] = {
			"trnsWayCd" : trnsWayCd
			, "trnsId" : trnsId
			, "prdctDetlId" : prdctDetlId
		};
		
		let promise = common.promise.ajax(jsonData, "", false);
			promise = promise.then((o)=> {
				if (o) {
					if (o.statusCode===`S`) {
						if($(target).hasClass("on")){
							$(target).removeClass("on");
							$(target).children("img")[0].src = "/contents/images/client/icon/icon-unLike.svg";
						}else{
							$(target).addClass("on");
							$(target).children("img")[0].src = "/contents/images/client/icon/icon-Like.svg";
						}
					}
				}
		});
	}else{
		common.alert("로그인 후 이용하시기바랍니다.");
	}
}


/*
 * 농산물 온라인 도매시장 거래상품 영역 상품 html
 */
scwin.fnMakeDmItem = (list, areaId) => {
	var html = '';
	if(list != null && list.length > 0){
		list.forEach(item => {
			var likeBtn = '/contents/images/client/icon/icon-unLike.svg';
			var likeOn = "";
			if(item.intrstPrdctConno != null && item.intrstPrdctConno != ''){
				likeBtn = '/contents/images/client/icon/icon-Like.svg';
				likeOn = "on";
			}
			
			html += '<li class="trading-item">';
			html += '	<a href="#" onclick="scwin.fnGoDmDtl(\''+ item.trnsWayCd +'\', \''+ item.trnsId +'\', \''+ item.prdctId +'\', \''+ item.prdctDetlId +'\'); return false;">';	
			html += '		<figure><img src="'+ item.filePath +'" alt="'+ item.trnsNm +'" onerror="this.src=\'/contents/images/client/no-image.png\'"></figure>';	
			html += '		<div class="trading-title">';	
			html += '			<span class="body-18 ">'+ item.firmNm	+'</span>';
			html += '			<div class="inner-title">';	
			html += '				<strong class="body-24-m">'+ item.trnsNm +'</strong>';	
			html += '			</div>';	
			html += '			<p>';
			if(item.trnsWayCd != '002'){
			html += '				<b class="title-24-b "><sbux-label uitype="normal" text="'+ item.trnsUnprc +'" mask ="{ \'alias\': \'currency\', \'suffix\': \'\' , \'prefix\': \'\', \'digits\': 0 }"></sbux-label><small class="body-15 font-700">원</small></b>';					
			}else{
				html += '<b class="title-24-b ">&nbsp;</b>'
			}
			html += '			</p>';	
			html += '			<div class="inner-detail body-16">'
			html += '			<p><span class="addition">품목/품종</span> <span>'+ item.mclsNm +'/'+ item.sclsNm +'</span></p>';
			html += '			<p><span class="addition">단위/포장</span> <span>'+ item.trnsPrut.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',') + item.trnsUnitNm + item.frprdPacknNm +'</span></p>';
			html += '			<p><span class="addition">수량</span> <span>'+ (item.trnsWayCd == '001'? item.rmndrQntt.toString().maskMoney() : item.trnsQntt.toString().maskMoney()) +'</span></p>';
			html += '			</div>'
			html += '		</div>'
			html += '	</a>'
			if(scvar.firmTypeCd != '001' && item.trnsWayCd != '003'){
				html += '	<sbux-button uitype="normal" text="" value="button" image-src="'+ likeBtn +'" class="like-btn '+ likeOn +'" onclick="scwin.fnLike(\''+ item.trnsWayCd +'\', \''+ item.trnsId +'\', \''+ item.prdctDetlId +'\', this)"></sbux-button>'				
			}
			
			html += '</li>'
		})
	}else{
		html = '<li class="empty-list">';
		html += '	<figure>';
		html += '		<img class="empty-list-image" src="/contents/images/client/icon/icon-empty-list.png" alt="상품목록 없음">';
		html += '	</figure>';
		html += '	<h4 class="body-20 color-gray6 font-500 mt-30">등록된 상품이 없습니다.</h4>';
		html += '</li>';
	}
	
	$("#"+areaId).html(html);
	SBUxMethod.render("^"+areaId);
}

/*
 * 주취급 품목, 관심 상품 목록 html
 */
scwin.fnMakeIntrst = (list, areaId) => {
	var html = '';
	if(list != null && list.length > 0){
		list.forEach(item => {
			var itemCss = "";
			if(item.trnsWayCd == '001'){
				itemCss = "price-deal"
			}else if (item.trnsWayCd == '002'){
				itemCss = "bid-deal";
			}else if (item.trnsWayCd == '003'){
				itemCss = "contract-deal";
			}
			
			html += '<li>';
			html += '	<a href="#" class="d-flex" onclick="scwin.fnGoDmDtl(\''+ item.trnsWayCd +'\', \''+ item.trnsId +'\', \''+ item.prdctId +'\', \''+ item.prdctDetlId +'\'); return false;">';
			html += '		<div class="d-flex">';
			html += '			<div class="recent-img-wrap">';
			html += '				<img src="'+ item.filePath +'" alt="'+ item.trnsNm +'" onerror="this.src=\'/contents/images/client/no-image.png\'">';
			html += '			</div>';
			html += '			<div class="recent-text-wrap ml-10">';
			html += '				<div>';
			html += '					<p class="body-14">'+ item.firmNm +'</p>';
			html += '					<h4 class="body-16 font-500 recent-title">'+ item.trnsNm +'</h4>';
			html += '				</div>';
			html += '				<strong class="body-18 font-700"><sbux-label uitype="normal" text="'+ item.trnsUnprc +'" mask ="{ \'alias\': \'currency\', \'suffix\': \'\' , \'prefix\': \'\', \'digits\': 0 }"></sbux-label><span>원</span></strong>';
			html += '			</div>';
			html += '		</div>';
			html += '	</a>';
			html += '</li>';
		})
	}else{
		html = '<li class="empty-list">';
		html += '	<figure>';
		html += '		<img class="empty-list-image" src="/contents/images/client/icon/icon-empty-list.png" alt="상품목록 없음">';
		html += '	</figure>';
		html += '	<h4 class="body-20 color-gray6 font-500 mt-30">등록된 상품이 없습니다.</h4>';
		html += '</li>';
		
	}
	
	$("#"+areaId).html(html);
	SBUxMethod.render("^"+areaId);
}


/*
 * 상품 상세 페이지 이동
 */
scwin.fnGoDmDtl = (trnsWayCd, trnsId, prdctId, prdctDetlId) => {
	var url = "";
	var _param = {};
	var promise = common.getSessionInfo("mmno");
	promise = promise.then((session) => {
		var _mmno = session.mmno;
		
		if(!common.isEmpty(_mmno)){
			switch(trnsWayCd) {
				case '001' : 
					//정가거래
					url = "/client/tm/ntprc/trnsRgstnPrdctDtlPage.do?prdctDetlId=" + prdctDetlId + "&ntprcTrnsRgstnConno=" + trnsId;
					_param.prdctId = prdctId;
					_param.prdctDetlId = prdctDetlId;
					_param.ntprcTrnsRgstnConno = trnsId;
					_param.returnUrl = '/client/mn/main/main.do';
					break;
				case '002' :
					//입찰거래
					url = "/client/dm/bid/bidEftInfoDtl.do";
					_param.bidId = trnsId;
					_param.returnUrl = '/client/mn/main/main.do';
					break;
				case '003' :
					//역경매거래
					url = "/client/tm/auct/selectAuct.do";
					_param.trnsId = trnsId;
					_param.returnUrl = '/client/mn/main/main.do';
					break;
			}
			
			if(!common.isEmpty(url)){
				common.net.setHrefData(url, _param);
			}else{
				common.alert("거래정보가 존재하지 않습니다.")
			}
		}else{
			common.alert("로그인 후 이용해주시기바랍니다.");
			return false;
		}
		
	});
}

/*
 * 주문/배송 상세 페이지 이동
 */
scwin.fnGoOrdrDtl = (ordrNo) => {
	common.net.setHrefData(`/client/om/ordrdl/ordrDlDetlPage.do`, {"ordrNo": ordrNo});
}

/*
 * 판매자 Q&A 목록 페이지 이동
*/
scwin.fnGoSlerQnaList = () => {
	common.net.setHrefData("/client/sm/bbs/cmmn/1000000004/bbscttListPage.do", {});
	
}
 
/*
 * 판매자 Q&A 상세 페이지 이동
*/
scwin.fnGoSlerQnaDtl = (bbsNo) => {
	var jsonData = {};
	jsonData["action"] = "/api/client/sm/bbs/cmmn/selectMainData.do"
	jsonData["reqDoc"] = {
		"bbsInfoNo": "1000000004"
		, "bbsNo": bbsNo
		, "tabSlerFirmNo": '${firmNo}'
	}
	
	var promise = common.net.ajax(jsonData);
	promise = promise.then((o) => {
		if(o) {
			jsonData["action"] = "/api/client/sm/bbs/cmmn/selectQnaData.do"
			jsonData["reqDoc"] = o.resultData.data;
			jsonData["reqDoc"].bbsInfoNo = "1000000004";
			common.net.setHrefData("/client/sm/bbs/cmmn/1000000004/bbscttDtlPage.do", {"jsonData": jsonData});
		}
	});
}

/*
 * 구매자 배송현황 목록 조회
*/
scwin.fnPrchrDlvy = () => {
	
	let jsonData = {};
	jsonData["action"] = "/api/client/mn/main/selectListOrdrDlvy.do";
	
	let promise = common.promise.ajax(jsonData, "", false);
		promise = promise.then((o)=> {
			if (o) {
				if (o.statusCode===`S`) {
					
					var html = "";
					var list = o.resultData.list;
					if(list != null && list.length > 0){
						list.forEach(item => {
							var colorCss = "";
							switch (item.ordrPrdctStatCd){
								case 'D032' :
									colorCss = "color-gray6";
									break;
								case 'D041' :
									colorCss = "color-red";
									break;
								case 'D042' :
									colorCss = "color-green";
									break;
							}

							html += '<li>';
							html += '	<a href="#" class="d-flex justify-between" onclick="scwin.fnGoOrdrDtl(\''+ item.ordrNo +'\'); return false;">';
							html += '		<div class="item-info">';
							html += '			<h5 class="body-16 font-500">'+ item.trnsNm +'</h5>';
							html += '			<p class="date color-gray6"><sbux-label uitype="normal" text="'+ item.ordrYmd +'" mask = "{ \'alias\': \'yyyy-mm-dd\', \'autoUnmask\': true}"></sbux-label></p>';
							html += '			<p class="body-14 font-500"><sbux-label uitype="normal" text="'+ item.ordrUnprc +'" mask = "{ \'alias\': \'currency\', \'suffix\': \'원\', \'prefix\' : \'\', \'digits\' : 0}"></sbux-label> / <sbux-label uitype="normal" text="'+ item.ordrQntt +'" mask = "{ \'alias\': \'currency\', \'suffix\': \'개\', \'prefix\' : \'\', \'digits\' : 0}""></sbux-label></p>';
							html += '		</div>';
							html += '		<div class="mark">';
							html += '			<span class="body-14 '+ colorCss +'">'+ item.ordrPrdctStatNm +'</span>';
							html += '		</div>';
							html += '	</a>';
							html += '</li>';
						});
						
					}else{
						html = '<li class="empty-list">';
						html += '	<figure>';
						html += '		<img class="empty-list-image" src="/contents/images/client/icon/icon-empty-list.png" alt="상품목록 없음">';
						html += '	</figure>';
						html += '	<h4 class="body-20 color-gray6 font-500 mt-30">배송정보가 존재하지 않습니다.</h4>';
						html += '</li>';
					}
					
					$("#prchr_dlvy_list").html(html);
					SBUxMethod.render("^prchr_dlvy_list");
				}
			}
	});
}

/*
 * 상위 거래품목 데이터 조회
 */
scwin.fnGetTopSix = () => {
	let jsonData = {};
	jsonData["action"] = "/api/client/mn/main/selectListSclsTopSix.do";
	
	let promise = common.promise.ajax(jsonData, "", false);
	promise = promise.then((o)=> {
		if (o) {
			if (o.statusCode===`S`) {
				var list = o.resultData.list
				//TODO: 임시 데이터
				/* list = [
					{"mclsNm" : "양파", "tone" : "7716"},
					{"mclsNm" : "무", "tone" : "6134"},
					{"mclsNm" : "배추", "tone" : "3898"},
					{"mclsNm" : "대파", "tone" : "3601"},
					{"mclsNm" : "감자", "tone" : "3518"},
					{"mclsNm" : "양배추", "tone" : "3382"},
				] */
				
				scwin.fnDrawDonutChat(list);
				var colorCss = ['lightblue', "turquoise", "lightgreen", "yellow", "purple", "coral"];
				var html = '';
				if(list != null && list.length > 0) {
					
					list.forEach((item, index) => {
						html += '<li class="d-flex align-center">';
						html += '	<p class="d-flex align-center w-fixed">';
						html += '		<span class="circle '+ colorCss[index] +'"></span>';
						html += '		<span class="font-300">'+ item.mclsNm +'</span>';
						html += '	</p>';
						html += '	<p class="font-700"><sbux-label uitype="normal" text="'+ item.tone +'" mask = "{ \'alias\': \'currency\', \'suffix\': \'t\', \'prefix\' : \'\', \'digits\' : 0}"></sbux-label></p>';
						html += '</li>';
					});
				}
				
				$("#donut_char_legend").html(html);
				SBUxMethod.render("^donut_char_legend");
			}
		}
	});
}

/*
 * 최근 실적 7일 데이터 조회
 */
scwin.fnGetWeekOrdr = () => {
	let jsonData = {};
	jsonData["action"] = "/api/client/mn/main/selectListWeekOrdr.do";
	
	let promise = common.promise.ajax(jsonData, "", false);
	promise = promise.then((o)=> {
		if (o) {
			if (o.statusCode===`S`) {
				var list = o.resultData.list
				//TODO: 임시 데이터
				/* list = [
					{"groupDay" : '20230819', "weekNm": "월", "tone": "15", "amt" : "12"},
					{"groupDay" : '20230820', "weekNm": "화", "tone": "17", "amt" : "18"},
					{"groupDay" : '20230821', "weekNm": "수", "tone": "24", "amt" : "13"},
					{"groupDay" : '20230822', "weekNm": "목", "tone": "36", "amt" : "17"},
					{"groupDay" : '20230823', "weekNm": "금", "tone": "24", "amt" : "14"},
					{"groupDay" : '20230824', "weekNm": "토", "tone": "26", "amt" : "15"},
					{"groupDay" : '20230825', "weekNm": "일", "tone": "17", "amt" : "16"}
				] */
				scwin.fnDrawComboChat(list);
				$("#to_day_cnt").text(common.mask.money(list[6].tone.toString()) + " ");
				$("#to_day_amt").text(common.mask.money(list[6].amt.toString()) + " ");
[O			}
		}
	});
}
/*
 * 전체 누적 거래 물량/금액 조회
 */
scwin.fnGetTotOrdr = () => {
	let jsonData = {};
	jsonData["action"] = "/api/client/mn/main/selectTotOrdr.do";
	
	let promise = common.promise.ajax(jsonData, "", false);
	promise = promise.then((o)=> {
		if (o) {
			if (o.statusCode===`S`) {
				var data = o.resultData.data
				
				//TODO: 임시 데이터
				//$("#total_cnt").text(common.mask.money("7216") + " ");
				//$("#total_amt").text(common.mask.money("472") + " ");
				$("#total_cnt").text(common.mask.money(data.totTone.toString()) + " ");
				$("#total_amt").text(common.mask.money(data.totAmt.toString()) + " ");
			}
		}
	});
}

/*
 * 구매자 거래현황 조회
 */
scwin.fnGetPrchrOrdrStat = () => {
	let jsonData = {};
	jsonData["action"] = "/api/client/mn/main/selectPrchrOrdrStat.do";
	
	let promise = common.promise.ajax(jsonData, "", false);
	promise = promise.then((o)=> {
		if (o) {
			if (o.statusCode===`S`) {
				var data = o.resultData.data
				
				$("#dlngAprvCnt").text(data.dlngAprvCnt);
				$("#dlngOrderCnt").text(data.dlngOrderCnt);
				$("#endCnt").text(data.endCnt);
				$("#ntprcCnt").text(data.ntprcCnt);
				$("#partcptnCnt").text(data.partcptnCnt);
				$("#preCnt").text(data.preCnt);
				$("#scbdCnt").text(data.scbdCnt);
				$("#strtCnt").text(data.strtCnt);
			}
		}
	});
}

/*
 * 판매자 주문/배송 현황 조회
 */
scwin.fnGetSlerOrdrDlvyStat = () => {
	let jsonData = {};
	jsonData["action"] = "/api/client/mn/main/selectSlerOrdrDlvyStat.do";
	
	let promise = common.promise.ajax(jsonData, "", false);
	promise = promise.then((o)=> {
		if (o) {
			if (o.statusCode===`S`) {
				var data = o.resultData.data;
				$("#ordrDlvyOrdrCnt").text(data.ordrCnt);
				$("#ordrDlvyOrdrReadyCnt").text(data.ordrReadyCnt);
				$("#ordrDlvyDlvyCnt").text(data.dlvyCnt);
				$("#ordrDlvyDlvyDoneCnt").text(data.dlvyDoneCnt);
				$("#ordrDlvyAcptnCnt").text(data.acptnCnt);
				$("#ordrDlvyBuyAprvCnt").text(data.buyAprvCnt);
			}
		}
	});
}

/*
 * 판매자 거래현황 
 */
scwin.fnGetSlerTrnsStat = () => {
	let jsonData = {};
	jsonData["action"] = "/api/client/mn/main/selectSlerTrnsStat.do";
	
	let promise = common.promise.ajax(jsonData, "", false);
	promise = promise.then((o)=> {
		if (o) {
			if (o.statusCode===`S`) {
				var data = o.resultData.data;
				$("#trnsBidCnt").text(data.bidCnt);
				$("#trnsBidEndCnt").text(data.bidEndCnt);
				$("#trnsNtprcCnt").text(data.ntprcCnt);
				$("#trnsReqDlngCnt").text(data.reqDlngCnt);
				$("#trnsReqRefundCnt").text(data.reqRefundCnt);
				$("#trnsReqTrnsCnt").text(data.reqTrnsCnt);
				$("#trnsScbdCnt").text(data.scbdCnt);
			}
		}
	});
}


/*
 * 판매샵 문의목록 조회
 */
scwin.fnGetShopQna = () => {
	let jsonData = {};
	jsonData["action"] = "/api/client/mn/main/selectListShopQna.do";
	
	let promise = common.promise.ajax(jsonData, "", false);
	promise = promise.then((o)=> {
		if (o) {
			if (o.statusCode===`S`) {
				var list = o.resultData.list;
				scwin.fnMakeShopQna(list);
			}
		}
	});
}

/*
 * 판매샵 문의 목록 생성
 */
scwin.fnMakeShopQna = (list) => {
	var html = "";
	if(list != null && list.length > 0){
		SBUxMethod.set("shopQnaCnt", list[0].ansWaitCnt);
		list.forEach(item => {
			
			var colorCss = "";
			if(item.ansStatCd == '003'){
				colorCss = "color-green";
			}
			
			html += '<li>';
			html += '	<a href="#" onclick="scwin.fnGoSlerQnaDtl(\''+ item.bbsNo +'\'); return false;">';
			html += '		<span>'+ item.ttl +'</span>';
			html += '		<strong class="'+ colorCss +'">'+ item.ansStatNm +'</strong>';
			html += '	</a>';
			html += '</li>';
		});
		
	}else{
		html = '<li class="empty-list">';
		html += '	<figure>';
		html += '		<img class="empty-list-image" src="/contents/images/client/icon/icon-empty-list.png" alt="상품목록 없음">';
		html += '	</figure>';
		html += '	<h4 class="body-20 color-gray6 font-500 mt-30">등록된 문의가 없습니다.</h4>';
		html += '</li>';
	}
		
	$("#shop_qna_list").html(html);
}

/*
 * 팝업 조회
 */
scwin.fnGetPopupList = () => {
	let jsonData = {};
	jsonData["action"] = "/api/client/mn/main/selectListMainPopup.do";
	
	let promise = common.promise.ajax(jsonData, "", false);
	promise = promise.then((o)=> {
		if (o) {
			if (o.statusCode===`S`) {
				var list = o.resultData.list;
				
				if(list != null && list.length > 0){
					//"/client/mn/main/mainPopup.do"
					
					list.forEach(item => {
						
						var cookie = $.cookie("mainpopup_" + item.popupNo);
						if(common.isEmpty(cookie)){
							if(item.popupTypeCd == '001') {
								//레이어
								common.promise.layerOpen(["openPop"+ item.popupNo, item.ttl, "/client/mn/main/mainLayerPopup.do", item.popupWdwWdthSize, item.popupWdwVrtcSize], {"param": item});
							}else if(item.popupTypeCd == '002') {
								//윈도우
								var popupWdwLeftLocaVl = item.popupWdwLeftLocaVl;
								var popupWdwTopLocaVl = item.popupWdwTopLocaVl;
								
								if(item.popupWdwLocaVl==='leftTop'){
									popupWdwLeftLocaVl = '0';
									popupWdwTopLocaVl = '0';
								}
								else if(item.popupWdwLocaVl==='centerTop'){
									popupWdwLeftLocaVl = screenX + (window.innerWidth/2 - item.popupWdwWdthSize/2);
									popupWdwTopLocaVl = '0';
								}
								else if(item.popupWdwLocaVl==='rightTop'){
									popupWdwLeftLocaVl = screenX + window.innerWidth - item.popupWdwWdthSize;
									popupWdwTopLocaVl = '0';
								}
								else if(item.popupWdwLocaVl==='center'){
									popupWdwLeftLocaVl = screenX + (window.innerWidth - item.popupWdwWdthSize)/2;
									popupWdwTopLocaVl = (window.innerHeight - item.popupWdwVrtcSize)/2;
								}
								
								common.promise.popopen(["openPop"+ item.popupNo, item.ttl , "/client/mn/main/mainWinPopup.do?popupNo=" + item.popupNo +"&left=" + popupWdwLeftLocaVl + "&top=" + popupWdwTopLocaVl, item.popupWdwWdthSize, item.popupWdwVrtcSize, false, false, false]);
							}
						}
					});
					
				}
			}
		}
	});

}

/*
 * 거래현황 링크
 */
scwin.fnGoDmList = (trns_way_cd, prog_stat_cd) => {
	var url = '';
	var _param = {};
	if(!common.isEmpty(scvar.firmTypeCd)){
		if(scvar.firmTypeCd == '001'){
			//판매자
			switch (trns_way_cd) {
				case '001' : 
					//정가
					url = '/client/dm/ntprc/slerNtprcList.do'
					break;
				case '002' :
					//입찰
					url = '/client/dm/bid/slerFirmBidList.do';
					break;
				case '003' :
					//역입찰
					url = '/client/dm/da/ntslList.do'
					break;
				case '004' :
					//발주
					url = '/client/dm/order/myshopOrderList.do';
					break;
				default : 
					//(교환/반품)
					url = '/client/om/reqst/slerList.do';
					_param = {
						"srchOrdrPrdctStatCd" : prog_stat_cd
					}
					break;
			}
			
			common.net.setHrefData(url, _param);
		}else if(scvar.firmTypeCd == '002'){
			//구매자
			switch (trns_way_cd) {
				case '001' : 
					//정가
					url = '/client/dm/ntprc/prchrNtprcList.do'
					break;
				case '002' :
					//입찰
					url = '/client/dm/bid/prchrFirmBidList.do';
					break;
				case '003' :
					//역입찰
					url = '/client/dm/da/prchsList.do'
					break;
				case '004' :
					//발주
					url = '/client/dm/order/orderList.do';
					break;
			}
			common.net.setHrefData(url, _param);
		}
	}else{
		common.alert("로그인 후 이용해주시기바랍니다.");
	}
}

/*
 * 주문/배송 링크
 */
scwin.fnGoOrdrList = (prog_stat_cd) => {
	var url;
	var _param = {};
	
	if(!common.isEmpty(scvar.firmTypeCd) && scvar.firmTypeCd == '001'){
		//판매자
		url = '/client/om/ordrmng/ordrMngListPage.do';
		/* ordrmngSrchParam */
		_param = {
			"srchOrdrPrdctStatCd" : prog_stat_cd
		}
		
		sessionStorage.setItem("ordrmngSrchParam", JSON.stringify(_param));
		
		common.net.setHrefData(url, {});
	}else{
		common.alert("로그인 후 이용해주시기바랍니다.");
	}
	
	
}

/*
 * 시즌 베스트 조회
 */
scwin.fnGetSeasonBest = () => {
	let jsonData = {};
	jsonData["action"] = "/api/client/mn/main/selectListSeasonBest.do";
	
	let promise = common.promise.ajax(jsonData, "", false);
	promise = promise.then((o)=> {
		if (o) {
			if (o.statusCode===`S`) {
				var list = o.resultData.list;
				scwin.fnMakeSeasonBest(list);
			}
		}
	});
}

/*
 * 시즌 베스트 html 생성
 */
scwin.fnMakeSeasonBest = (list) => {
	if(list != null && list.length > 0){
		var html = '';
		list.forEach(item => {
			var _weekCss = '';
			var _monthCss = '';
			var _yearCss = '';
			var _rateCss = '';
			
			if(item.weekRate > 0){
				_rateCss = 'increase';
				_weekCss = 'color-red';
			}else if(item.weekRate < 0){
				_rateCss = 'decrease';
				_weekCss = 'color-blue';
			}
			
			if(item.monthRate > 0){
				_monthCss = 'color-red';
			}else if(item.monthRate < 0){
				_monthCss = 'color-blue';
			}
			
			if(item.yearRate > 0){
				_yearCss = 'color-red';
			}else if(item.yearRate < 0){
				_yearCss = 'color-blue';
			}
			
			html += '<div class="swiper-slide best-item-slide">';
			html += '	<div class="slide-top d-flex">';
			html += '		<div class="item-img-wrap">';
			html += '			<img src="'+ item.filePath+'" alt="'+ item.mclsNm +'">';
			html += '		</div>';
			html += '		<div class="slide-top-text body-24-m">';
			html += '			<p>'+ item.mclsNm +'</p>';
			html += '			<p class="item-price color-gray5 body-24-m"><span class="color-black"><sbux-label uitype="normal" text="'+ item.todayPrice+'" mask = "{ \'alias\': \'currency\', \'suffix\': \'\' , \'prefix\': \' \', \'digits\': 0 }"></sbux-label></span>원 / kg </p>';
			html += '		</div>';
			html += '	</div>';
			html += '	<div class="slide-bottom d-flex">';
			html += '		<div class="rate-graph '+ _rateCss +'">';
			html += '		</div>';
			html += '		<ul class="slide-rate-wrap d-flex">';
			html += '			<li>';
			html += '				<p>전주대비</p>';
			html += '				<p class="rate-num '+ _weekCss +'">'+ (item.weekRate == 0? "-" : item.weekRate + "%") +'</p>';
			html += '			</li>';
			html += '			<li>';
			html += '				<p>전월대비</p>';
			html += '				<p class="rate-num '+ _monthCss +'">'+ (item.monthRate == 0? "-" : item.monthRate + "%") +'</p>';
			html += '			</li>';
			html += '			<li>';
			html += '				<p>전년대비</p>';
			html += '				<p class="rate-num '+ _yearCss +'">'+ (item.yearRate == 0? "-" : item.yearRate + "%") +'</p>';
			html += '			</li>';
			html += '		</ul>';
			html += '	</div>';
			html += '</div>';
		});
		$("#season_best_wrap").append(html);
		SBUxMethod.render("^season_best_wrap");
		scwin.fnMakeSwiper();
	}
}

scwin.fnMakeSwiper = () => {
	var swiper = new Swiper(".mySwiper", {
		slidesPerView: 1,
		spaceBetween: 20,
		navigation: {
			nextEl: ".swiper-button-next",
			prevEl: ".swiper-button-prev",
		},
		pagination: {
			el: ".swiper-pagination",
		},
		breakpoints: {
			481: {
				slidesPerView: "auto",
			}
		},
	});
}

/*
 * 도매시장 가격정보 조회
 */
scwin.fnGetMarketPriceInfo = () => {
	var _mapping = [{"name":"SBUx_JS1_JSON5", "value" : "06"}
		,{ "name" : "SBUx_IDE1_JSON5", "value" : "09"}
		,{ "name" : "SBUx_IDE2_JSON2", "value" : "12"}
		,{ "name" : "SBUx_IDE3_JSON2", "value" : "10"}
		,{ "name" : "SBUx_IDE4_JSON2", "value" : "13"}
		,{ "name" : "SBUx_IDE5_JSON2", "value" : "11"}
		,{ "name" : "SBUx_IDE6_JSON2", "value" : "05"}
		,{ "name" : "SBUx_IDE7_JSON2", "value" : "08"} //과일과채류
		,{ "name" : "SBUx_IDE8_JSON2", "value" : "17"} //버섯류
		,{ "name" : "SBUx_IDE9_JSON2", "value" : "07"} //수실류
	];
	
	_mapping.forEach(item => {
		let jsonData = {};
		jsonData["action"] = "/api/client/mn/main/selectListMarketPriceInfo.do";
		jsonData["reqDoc"] = {
			"lclsCd" : item.value
		};
		let promise = common.promise.ajax(jsonData, "", false);
		promise = promise.then((o)=> {
			if (o) {
				if (o.statusCode===`S`) {
					var list = o.resultData.list;
					scwin.fnMakeMarketPrice(list, item);
					
				}
			}
		});
	});
}

/*
 * 도매시장 가격정보 테이블 생성
 */
scwin.fnMakeMarketPrice = (list, item) => {
	var _mclsNmDiv = document.createElement("div")
	_mclsNmDiv.classList.add("bot__left");
	var _infoDiv = document.createElement("div")
	_infoDiv.classList.add("bot__right");
	var _bodyDiv = document.querySelector("#" + item.name + " .market_price_body");
	_bodyDiv.append(_mclsNmDiv);
	_bodyDiv.append(_infoDiv);
	
	list.forEach(info => {
		var _mclsNm = '<p class="left__item">'+ info.mclsNm +'</p>';
		_mclsNmDiv.innerHTML += _mclsNm;
		
		var _dataDiv = document.createElement("div");
		_dataDiv.classList.add("right__list");
		
		var _rateCss = "";
		if(item.priceRate > 0){
			_rateCss = "up";
		}else if(item.priceRate < 0){
			_rateCss = "down";
		}
		
		var _dataHtml = '<p class="right__item">1kg</p>';
			_dataHtml += '<p class="right__item"><sbux-label uitype="normal" text="'+ info.todayPrice+'" mask = "{ \'alias\': \'currency\', \'suffix\': \'\' , \'prefix\': \' \', \'digits\': 0 }"></sbux-label></p>';
			_dataHtml += '<p class="right__item '+ _rateCss +'">'+ (info.priceRate == 0? "-" : info.priceRate + "%") +'</p>';
			_dataHtml += '<p class="right__item"><sbux-label uitype="normal" text="'+ info.yesterPrice+'" mask = "{ \'alias\': \'currency\', \'suffix\': \'\' , \'prefix\': \' \', \'digits\': 0 }"></sbux-label></p>';
			_dataHtml += '<p class="right__item"><sbux-label uitype="normal" text="'+ info.monthPrice+'" mask = "{ \'alias\': \'currency\', \'suffix\': \'\' , \'prefix\': \' \', \'digits\': 0 }"></sbux-label></p>';
			_dataHtml += '<p class="right__item"><sbux-label uitype="normal" text="'+ info.yearPrice+'" mask = "{ \'alias\': \'currency\', \'suffix\': \'\' , \'prefix\': \' \', \'digits\': 0 }"></sbux-label></p>';
		_dataDiv.innerHTML = _dataHtml;
		_infoDiv.append(_dataDiv);
	});
	SBUxMethod.render("^" + item.name);
}

scwin.onpageload = function() {
	scvar.firmTypeCd = '${firmTypeCd}';
	
	/* ======================================================================== */
	/* =====================	전체 사용자 공통 영역		===================== */
	/* ======================================================================== */
	//농산물 온라인 도매시장 거래상품 목록 조회
	scwin.fnGetNtprc(); //정가거래
	//scwin.fnGetBid01(); //입찰거래
	//scwin.fnGetBid02(); //역경매

	//상단 통계 영역
	scwin.fnGetTotOrdr(); //누적 거래 실적
	scwin.fnGetWeekOrdr(); //최근 실적
	scwin.fnGetTopSix(); // 상위 거래품목
	
	//TODO: 시즌 베스트 임시 주석 처리
	//scwin.fnGetSeasonBest(); //시즌 베스트
	//scwin.fnGetMarketPriceInfo(); //도매시장 가격정보
	
	if(!common.isEmpty(scvar.firmTypeCd)){
		if(scvar.firmTypeCd == '001'){
			/* ======================================================================== */
			/* =====================				 판매자 영역			 ===================== */
			/* ======================================================================== */
			scwin.fnGetSlerOrdrDlvyStat(); //주문,배송 현황
			scwin.fnGetShopQna(); //고객 문의 목록
			scwin.fnGetSlerTrnsStat(); //나의 거래현황
			
			$(".seller-check-wrap").show();
		}else if(scvar.firmTypeCd == '002'){
			/* ======================================================================== */
			/* =====================				 구매자 영역			 ===================== */
			/* ======================================================================== */
			//관심 상품 영역 조회
			scwin.fnGetIntrst002(); //최근본상품
			//scwin.fnGetIntrst001(); //관심상품
			//scwin.fnGetIntrst004(); //관심품목
			
			scwin.fnGetPrchrOrdrStat(); //나의 거래현황
			scwin.fnPrchrDlvy(); //구매자 배송현황 목록
			
			$(".prchr_area").show();
		}
		
		scwin.fnGetMbrInfo();
	}
	else{
		scwin.fnGetPopupList(); //팝업 조회
	}
}

/*
 * 회원 정보 조회
 */
scwin.fnGetMbrInfo = () => {
	
	var jsonData = {};
	
	jsonData["action"] = "/client/co/login/mbrInfo.do";
	jsonData["reqDoc"] = {};
	
	let promise = common.promise.ajax(jsonData, "", false);
	promise = promise.then((o)=> {
		if (o) {
			if (o.statusCode===`S`) {
				var data = o.resultData.mbrInfo;
				
				if(data.firmStatCd === "005") { // 심사중
					var paramData = {};
				
					var promise = common.promise.layerOpen(["openPop", "회원심사 안내", "/client/co/login/judgeProgressPage.do", 750, 275], {"param": paramData});
						promise = promise.then(function(e) {
							//alert(`callback = ` + JSON.stringify(o));
							scwin.fnGetPopupList(); //팝업 조회
						});
				}
				else if(data.firmStatCd === "007") { // 중지
					var paramData = {data};
					
					var promise = common.promise.layerOpen(["openPop", "중지 계정 안내", "/client/co/login/stopPage.do", 750, 487], {"param": paramData});
						promise = promise.then(function(e) {
							//alert(`callback = ` + JSON.stringify(o));
							scwin.fnGetPopupList(); //팝업 조회
						});
				}
				else if(data.firmStatCd === "004") { // 반려
					var paramData = {data};
					
					var promise = common.promise.layerOpen(["openPop", "승인 반려 안내", "/client/co/login/rejectPage.do", 750, 637], {"param": paramData});
						promise = promise.then(function(e) {
							//alert(`callback = ` + JSON.stringify(o));
							return scwin.fnGetPopupList(); //팝업 조회
						});
				}
				else if(data.firmStatCd === "008") { // 서류보완
					var paramData = {data};
					
					var promise = common.promise.layerOpen(["openPop", "서류보완 안내", "/client/co/login/imprvPage.do", 750, 637], {"param": paramData});
						promise = promise.then(function(e) {
							//alert(`callback = ` + JSON.stringify(o));
							return scwin.fnGetPopupList(); //팝업 조회
						});
				}
				else {
					if(data.pwRcmndYn == 'Y') {
						var paramData = {data};
						
						var promise = common.promise.layerOpen(["openPop", "비밀번호 변경 안내", "/client/co/login/passwordRcmndPage.do", 750, 637], {"param": paramData});
							promise = promise.then(function(e) {
								//alert(`callback = ` + JSON.stringify(o));
								return scwin.fnGetPopupList(); //팝업 조회
							});
					}
					else {
						scwin.fnGetPopupList(); //팝업 조회
					}
				}
			}
		}
	});
}

</script>

<!-- 최근 실적	-->
<section class="performance-wrap">
	<h2 class="hidden">최근실적영역</h2>
	<div class="container-wrap d-flex">
		<div class="performance">
			<div class="performance-graph">
				<div class="d-flex">
					<h3 class="body-26-m font-700">최근 실적</h3>
					<ul class="chart-combi-legend">
						<li></li>
					</ul>
				</div>
				<!-- combi 차트 -->
				<div class="chart-combi" id="chart-combi"></div>
			</div>

			<div class="d-flex day-performance">
				<div class="d-flex">
					<p class="body-20 font-500">거래물량</p>
					<ul class="d-flex body-20">
						<li class="border d-flex align-end">
							<span class="body-20 font-500"> 금일 </span>
							<p><span class="color-green num" id="to_day_cnt"></span>톤</p>
						</li>
						<li class="d-flex align-end">
							<span class="body-20 font-500"> 누적 </span>
							<p><span class="color-green num" id="total_cnt"></span>톤</p>
						</li>
					</ul>
				</div>
				<div class="d-flex">
					<p class="body-20 font-500">거래금액</p>
					<ul class="d-flex body-20">
						<li class="border d-flex align-end">
							<span class="body-20 font-500"> 금일 </span>
							<p><span class="color-red num" id="to_day_amt"></span>만원</p>
						</li>
						<li class="d-flex align-end">
							<span class="body-20 font-500"> 누적 </span>
							<p><span class="color-red num" id="total_amt"></span>만원</p>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<div class="top-item">
			<h3 class="body-26-m font-700">상위 거래품목 <span class="color-gray6 body-20">(7일 기준)</span></h3>
			<div class="chart-donut-wrap">
				<div class="chart-donut" id="chart-donut"></div>
				<ul class="chart-donut-legend body-20" id="donut_char_legend">
					
				</ul>
			</div>
		</div>
	</div>
</section>

<!-- 로그인 후 판매자 화면 영역	-->
<section class="user-check-wrap seller-check-wrap" style="display:none;padding-bottom:5rem;">
	<h2 class="hidden">판매자 화면 영역</h2>
	<div class="container-wrap d-flex">
		<div class="transaction-wrap card">
			<h3 class="title-24-b">나의 거래현황</h3>
			<ul class="transaction-type d-flex">
				<li class="w-half border-right">
					<a href="#" onclick="scwin.fnGoDmList('002', ''); return false;">
						<p class="body-16">진행중<br/>입찰거래</p>
						<h4 class="color-red text-right" id="trnsBidCnt"></h4>
					</a>
				</li>
				<li class="w-half">
					<a href="#" onclick="scwin.fnGoDmList('002', ''); return false;">
						<p class="body-16">완료된<br/>입찰거래</p>
						<h4 class="color-red text-right" id="trnsBidEndCnt"></h4>
					</a>
				</li>
				<li class="w-half border-right border-top">
					<a href="#" onclick="scwin.fnGoDmList('001', ''); return false;">
						<p class="body-16">정가거래</p>
						<h4 class="color-blue text-right" id="trnsNtprcCnt"></h4>
					</a>
				</li>
				<li class="w-half border-top">
					<a href="#" onclick="scwin.fnGoDmList('003', ''); return false;">
						<p class="body-16">낙찰된<br />역입찰</p>
						<h4 class="color-blue text-right" id="trnsScbdCnt"></h4>
					</a>
				</li>
				<li class="border-right border-top">
					<a href="#" onclick="scwin.fnGoDmList('004', ''); return false;">
						<p class="body-16">발주거래<br />요청</p>
						<h4 class="text-right" id="trnsReqDlngCnt"></h4>
					</a>
				</li>
				<li class="border-right border-top">
					<a href="#" onclick="scwin.fnGoDmList('refund', 'D061'); return false;">
						<p class="body-16">반품<br />요청</p>
						<h4 class="text-right" id="trnsReqRefundCnt"></h4>
					</a>
				</li>
				<li class="border-top">
					<a href="#" onclick="scwin.fnGoDmList('refund', 'D071'); return false;">
						<p class="body-16">교환<br />요청</p>
						<h4 class="text-right" id="trnsReqTrnsCnt"></h4>
					</a>
				</li>
			</ul>
		</div>
		<div class="transaction-wrap card">
			<h3 class="title-24-b">주문/배송</h3>
			<ul class="transaction-type d-flex">
				<li class="w-half border-right">
					<a href="#" onclick="scwin.fnGoOrdrList('D031'); return false;">
						<p class="body-16">주문</p>
						<h4 class="color-red text-right" id="ordrDlvyOrdrCnt"></h4>
					</a>
				</li>
				<li class="w-half">
					<a href="#" onclick="scwin.fnGoOrdrList('D032'); return false;">
						<p class="body-16">상품준비</p>
						<h4 class="color-red text-right" id="ordrDlvyOrdrReadyCnt"></h4>
					</a>
				</li>
				<li class="w-half border-right border-top">
					<a href="#" onclick="scwin.fnGoOrdrList('D041'); return false;">
						<p class="body-16">운송중</p>
						<h4 class="text-right" id="ordrDlvyDlvyCnt"></h4>
					</a>
				</li>
				<li class="w-half border-top">
					<a href="#" onclick="scwin.fnGoOrdrList('D042'); return false;">
						<p class="body-16">운송완료</p>
						<h4 class="text-right" id="ordrDlvyDlvyDoneCnt"></h4>
					</a>
				</li>
				<li class="w-half border-right border-top">
					<a href="#" onclick="scwin.fnGoOrdrList('D051'); return false;">
						<p class="body-16">인수</p>
						<h4 class="color-blue text-right" id="ordrDlvyAcptnCnt"></h4>
					</a>
				</li>
				<li class="w-half border-top">
					<a href="#" onclick="scwin.fnGoOrdrList('D090'); return false;">
						<p class="body-16">구매확정</p>
						<h4 class="color-blue text-right" id="ordrDlvyBuyAprvCnt"></h4>
					</a>
				</li>
			</ul>
		</div>
		<div class="inquiry-status-wrap card">
			<div class="title-wrap d-flex justify-between align-end">
				<div class="align-end">
					<h3 class="title-24-b">고객 문의</h3>
					<p class="body-16 color-gray7">
						(미답변<span class="color-red"><sbux-label id="shopQnaCnt" name="shopQnaCnt" uitype="normal" text="0" mask = "{ 'alias': 'currency', 'suffix': '' , 'prefix': ' ', 'digits': 0 }"></sbux-label></span>건)
					</p>
				</div>
				<sbux-button uitype="normal" image-src="/contents/images/client/icon/icon-arrow-gray-s.svg" text="더보기" wrap-class="view-more-btn" onclick="scwin.fnGoSlerQnaList(); return false;"></sbux-button>
			</div>
			<div>

			</div>
			<div class="inquiry-list-wrap">
				<ul class="inquiry-list scrollbar body-16" id="shop_qna_list">
				</ul>
			</div>
		</div>
	</div>
</section>

<!-- 로그인 후 구매자 화면 영역	-->
<section class="user-check-wrap prchr_area" style="display:none;padding-bottom:5rem;">
	<h2 class="hidden">구매자 화면 영역</h2>
	<div class="container-wrap d-flex">
		<div class="transaction-wrap buyer card">
			<h3 class="title-24-b">나의 거래현황</h3>
			<ul class="transaction-type d-flex">
				<li class="border-right">
					<a href="#" onclick="scwin.fnGoDmList('002', ''); return false;">
						<p class="body-16">입찰참여</p>
						<h4 class="color-red text-right" id="partcptnCnt" ></h4>
					</a>
				</li>
				<li class="border-right">
					<a href="#" onclick="scwin.fnGoDmList('002', ''); return false;">
						<p class="body-16">입찰낙찰</p>
						<h4 class="color-red text-right" id="scbdCnt"></h4>
					</a>
				</li>
				<li>
					<a href="#" onclick="scwin.fnGoDmList('001', ''); return false;">
						<p class="body-16">정가매매</p>
						<h4 class="color-red text-right" id="ntprcCnt"></h4>
					</a>
				</li>
				<li class="border-top border-right">
					<a href="#" onclick="scwin.fnGoDmList('003', ''); return false;">
						<p class="body-16">진행예정 역입찰</p>
						<h4 class="color-blue text-right" id="preCnt"></h4>
					</a>
				</li>
				<li class="border-top border-right">
					<a href="#" onclick="scwin.fnGoDmList('003', ''); return false;">
						<p class="body-16">진행중 역입찰</p>
						<h4 class="color-blue text-right" id="strtCnt"></h4>
					</a>
				</li>
				<li class="border-top">
					<a href="#" onclick="scwin.fnGoDmList('003', ''); return false;">
						<p class="body-16">완료된 역입찰</p>
						<h4 class="color-blue text-right" id="endCnt"></h4>
					</a>
				</li>
				<li class="w-half border-top border-right">
					<a href="#" onclick="scwin.fnGoDmList('004', ''); return false;">
						<p class="body-16">발주거래 요청</p>
						<h4 class="text-right" id="dlngOrderCnt"></h4>
					</a>
				</li>
				<li class="w-half border-top">
					<a href="#" onclick="scwin.fnGoDmList('004', ''); return false;">
						<p class="body-16">발주거래 체결</p>
						<h4 class="text-right" id="dlngAprvCnt"></h4>
					</a>
				</li>
			</ul>
		</div>
		<div class="delivery-status-wrap card">
			<div class="title-wrap d-flex justify-between align-end">
				<h3 class="title-24-b">배송현황</h3>
				<sbux-button uitype="normal" image-src="/contents/images/client/icon/icon-arrow-gray-s.svg" text="더보기" wrap-class="view-more-btn" onclick="scwin.fnGoOrdrDlvyList(); return false;">
				</sbux-button>
			</div>
			<ul class="delivery-list scrollbar" id="prchr_dlvy_list">
			</ul>
		</div>
		<div class="payment-info-wrap d-flex">
			<div class="card">
				<h3 class="title-24-b">한도잔액</h3>
				<ul>
					<li>
						<p class="body-15 font-500 color-gray6">여신금액</p>
						<p class="body-18 font-500 text-right"><sbux-label uitype="normal" text="0" id="mainEgmAmt" name="mainEgmAmt" mask = "{ 'alias': 'currency', 'suffix': '원' , 'prefix': ' ', 'digits': 0 }"></sbux-label></p>
					</li>
					<li>
						<p class="body-15 font-500 color-gray6">한도금액</p>
						<p class="body-18 font-500 text-right"><sbux-label uitype="normal" text="0" id="mainRcvbRmndrBundAmt" name="mainRcvbRmndrBundAmt" mask = "{ 'alias': 'currency', 'suffix': '원' , 'prefix': ' ', 'digits': 0 }"></sbux-label></p>
					</li>
					<li>
						<p class="body-15 font-500 color-gray6">사용금액</p>
						<p class="body-18 font-500 text-right"><sbux-label uitype="normal" text="0" id="mainUseEgmAmt" name="mainUseEgmAmt" mask = "{ 'alias': 'currency', 'suffix': '원' , 'prefix': ' ', 'digits': 0 }"></sbux-label></p>
					</li>
					<li>
						<p class="body-15 font-500 color-gray6">사용가능금액</p>
						<p class="body-18 font-500 text-right color-blue"><sbux-label uitype="normal" text="0" id="mainRmdEgmAmt" name="mainRmdEgmAmt" mask = "{ 'alias': 'currency', 'suffix': '원' , 'prefix': ' ', 'digits': 0 }"></sbux-label></p>
					</li>
				</ul>
			</div>
			<div class="card">
				<h3 class="title-24-b">결제정보</h3>
				<ul>
					<li>
						<p class="body-15 font-500 color-gray6">결제 대상금액</p>
						<p class="body-18 font-500 text-right"><sbux-label uitype="normal" text="0" id="mainRcvbAmt" name="mainRcvbAmt" mask = "{ 'alias': 'currency', 'suffix': '원' , 'prefix': ' ', 'digits': 0 }"></sbux-label></p>
					</li>
					<li>
						<p class="body-15 font-500 color-gray6">입금액</p>
						<p class="body-18 font-500 text-right"><sbux-label uitype="normal" text="0" id="mainVrtlAcntRtmnAmt" name="mainVrtlAcntRtmnAmt" mask = "{ 'alias': 'currency', 'suffix': '원' , 'prefix': ' ', 'digits': 0 }"></sbux-label></p>
					</li>
					<li>
						<p class="body-15 font-500 color-gray6">이자</p>
						<p class="body-18 font-500 text-right"><sbux-label uitype="normal" text="0" id="mainItrAmt" name="mainItrAmt" mask = "{ 'alias': 'currency', 'suffix': '원' , 'prefix': ' ', 'digits': 0 }"></sbux-label></p>
					</li>
					<li>
						<p class="body-15 font-500 color-gray6">연체이자</p>
						<p class="body-18 font-500 text-right color-blue"><sbux-label uitype="normal" text="0" id="mainArrrgItrAmt" name="mainArrrgItrAmt" mask = "{ 'alias': 'currency', 'suffix': '원' , 'prefix': ' ', 'digits': 0 }"></sbux-label></p>
					</li>
				</ul>
			</div>
		</div>
		<div class="recent-area card">
			<sbux-tabs uitype="normal" class="tab_line" jsondata-ref="tabJsonData4" callback-after-select="scwin.fnGetIntrst"></sbux-tabs>
			<div class="tab-content">
				<div id="SBUx_JS2_JSON3">
					<ul class="scrollbar" id="item_list_intrst002">
					</ul>
					<sbux-button uitype="normal" text="최근 본 상품 더보기" class="recent_morebtn" wrap-class=" btn-green-white" title="최근 본 상품 더보기" onclick="scwin.fnGoInrstPrdctList('002');"></sbux-button>
				</div>
				<div id="SBUx_JS3_JSON3">
					<ul class="scrollbar" id="item_list_intrst004">
					</ul>
					<sbux-button uitype="normal" text="품목상품 더보기" class="recent_morebtn" wrap-class=" btn-green-white" title="품목상품 더보기" onclick="scwin.fnGoInrstPrdctList('004');"></sbux-button>
				</div>
				<div id="SBUx_JS4_JSON3">
					<ul class="scrollbar" id="item_list_intrst001">
					</ul>
					<sbux-button uitype="normal" text="관심 상품 더보기" class="recent_morebtn" wrap-class=" btn-green-white" title="관심상품 더보기" onclick="scwin.fnGoInrstPrdctList('001');"></sbux-button>
				</div>
			</div>
		</div>
	</div>
</section>

<!-- 시즌 베스트 품목 TODO:임시주석-->
<!-- 
<section class="best-item-wrap">
	<h2 class="container-wrap title-48-m">시즌 베스트 품목</h2>
	<div class="container-wrap">
		<div class="best-slide-wrap">
			<div class="swiper mySwiper">
				<div class="swiper-wrapper" id="season_best_wrap">
					
				</div>
			</div>
			<div class="swiper-pagination"></div>
			<div class="swiper-button-next"></div>
			<div class="swiper-button-prev"></div>
		</div>
	</div>
</section>
 -->
<!-- 도매 가격정보 TODO:임시주석	-->
<!-- <section class="wholesale-info-wrap bg-lightblue">
	<h2 class="container-wrap title-48-m">도매시장 가격정보</h2>
	<div class="container-wrap">
		<div class="wholesale-price">
			<script>
				var tabJsonData5 = [
					{ "id": "0", "pid": "-1", "order": "1", "text": "과실류", "targetid": "SBUx_JS1_JSON5", "targetvalue": "SBUX 탭" },
					{ "id": "1", "pid": "-1", "order": "2", "text": "과일과채류", "targetid": "SBUx_IDE7_JSON2", "targetvalue": "SBUX IDE탭7" },
					{ "id": "2", "pid": "-1", "order": "3", "text": "과채류", "targetid": "SBUx_IDE1_JSON5", "targetvalue": "SBUX IDE탭" },
					{ "id": "3", "pid": "-1", "order": "4", "text": "엽경채류", "targetid": "SBUx_IDE3_JSON2", "targetvalue": "SBUX IDE탭3" },
					{ "id": "4", "pid": "-1", "order": "5", "text": "조미채소류", "targetid": "SBUx_IDE2_JSON2", "targetvalue": "SBUX IDE탭2" },
					{ "id": "5", "pid": "-1", "order": "6", "text": "양채류", "targetid": "SBUx_IDE4_JSON2", "targetvalue": "SBUX IDE탭4" },
					{ "id": "6", "pid": "-1", "order": "7", "text": "근채류", "targetid": "SBUx_IDE5_JSON2", "targetvalue": "SBUX IDE탭5" },
					{ "id": "7", "pid": "-1", "order": "8", "text": "서류", "targetid": "SBUx_IDE6_JSON2", "targetvalue": "SBUX IDE탭6" },
					{ "id": "8", "pid": "-1", "order": "9", "text": "버섯류", "targetid": "SBUx_IDE8_JSON2", "targetvalue": "SBUX IDE탭8" },
					{ "id": "9", "pid": "-1", "order": "10", "text": "수실류", "targetid": "SBUx_IDE9_JSON2", "targetvalue": "SBUX IDE탭9" }
				];
			</script>
			<sbux-tabs id="market_price_tab" name="market_price_tab" uitype="normal" wrap-class="tab_line" jsondata-ref="tabJsonData5">
			</sbux-tabs>
			<div class="tab-content wholesale-price-cont">
				<div id="SBUx_JS1_JSON5">
					<div class="sbt-con-wrap">
						<div class="sbt-grid-wrap">
							<div class="sbt-wrap-header text-right body-18">
								(단위: 원)
							</div>
							<div class="wholesale-price-cont__sot">
								<div class="sot__top">
									<div class="top__left">
										<div class="left__item">품목</div>
									</div>
									<div class="top__right">
										<div class="right__item">단위</div>
										<div class="right__item">가격</div>
										<div class="right__item">등락률</div>
										<div class="right__item">전일</div>
										<div class="right__item">1개월전</div>
										<div class="right__item">1년전</div>
									</div>
								</div>
								<div class="sot__bot market_price_body">
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="SBUx_IDE1_JSON5">
					<div class="sbt-con-wrap">
						<div class="sbt-grid-wrap">
							<div class="sbt-wrap-header text-right body-18">
								(단위: 원)
							</div>
							<div class="wholesale-price-cont__sot">
								<div class="sot__top">
									<div class="top__left">
										<div class="left__item">품목</div>
									</div>
									<div class="top__right">
										<div class="right__item">단위</div>
										<div class="right__item">가격</div>
										<div class="right__item">등락률</div>
										<div class="right__item">전일</div>
										<div class="right__item">1개월전</div>
										<div class="right__item">1년전</div>
									</div>
								</div>
								<div class="sot__bot market_price_body">
									
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="SBUx_IDE2_JSON2">
					<div class="sbt-con-wrap">
						<div class="sbt-grid-wrap">
							<div class="sbt-wrap-header text-right body-18">
								(단위: 원)
							</div>
							<div class="wholesale-price-cont__sot">
								<div class="sot__top">
									<div class="top__left">
										<div class="left__item">품목</div>
									</div>
									<div class="top__right">
										<div class="right__item">단위</div>
										<div class="right__item">가격</div>
										<div class="right__item">등락률</div>
										<div class="right__item">전일</div>
										<div class="right__item">1개월전</div>
										<div class="right__item">1년전</div>
									</div>
								</div>
								<div class="sot__bot market_price_body">
									
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="SBUx_IDE3_JSON2">
					<div class="sbt-con-wrap">
						<div class="sbt-grid-wrap">
							<div class="sbt-wrap-header text-right body-18">
								(단위: 원)
							</div>
							<div class="wholesale-price-cont__sot">
								<div class="sot__top">
									<div class="top__left">
										<div class="left__item">품목</div>
									</div>
									<div class="top__right">
										<div class="right__item">단위</div>
										<div class="right__item">가격</div>
										<div class="right__item">등락률</div>
										<div class="right__item">전일</div>
										<div class="right__item">1개월전</div>
										<div class="right__item">1년전</div>
									</div>
								</div>
								<div class="sot__bot market_price_body">
									
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="SBUx_IDE4_JSON2">
					<div class="sbt-con-wrap">
						<div class="sbt-grid-wrap">
							<div class="sbt-wrap-header text-right body-18">
								(단위: 원)
							</div>
							<div class="wholesale-price-cont__sot">
								<div class="sot__top">
									<div class="top__left">
										<div class="left__item">품목</div>
									</div>
									<div class="top__right">
										<div class="right__item">단위</div>
										<div class="right__item">가격</div>
										<div class="right__item">등락률</div>
										<div class="right__item">전일</div>
										<div class="right__item">1개월전</div>
										<div class="right__item">1년전</div>
									</div>
								</div>
								<div class="sot__bot market_price_body">
									
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="SBUx_IDE5_JSON2">
					<div class="sbt-con-wrap">
						<div class="sbt-grid-wrap">
							<div class="sbt-wrap-header text-right body-18">
								(단위: 원)
							</div>
							<div class="wholesale-price-cont__sot">
								<div class="sot__top">
									<div class="top__left">
										<div class="left__item">품목</div>
									</div>
									<div class="top__right">
										<div class="right__item">단위</div>
										<div class="right__item">가격</div>
										<div class="right__item">등락률</div>
										<div class="right__item">전일</div>
										<div class="right__item">1개월전</div>
										<div class="right__item">1년전</div>
									</div>
								</div>
								<div class="sot__bot market_price_body">
									
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="SBUx_IDE6_JSON2">
					<div class="sbt-con-wrap">
						<div class="sbt-grid-wrap">
							<div class="sbt-wrap-header text-right body-18">
								(단위: 원)
							</div>
							<div class="wholesale-price-cont__sot">
								<div class="sot__top">
									<div class="top__left">
										<div class="left__item">품목</div>
									</div>
									<div class="top__right">
										<div class="right__item">단위</div>
										<div class="right__item">가격</div>
										<div class="right__item">등락률</div>
										<div class="right__item">전일</div>
										<div class="right__item">1개월전</div>
										<div class="right__item">1년전</div>
									</div>
								</div>
								<div class="sot__bot market_price_body">
									
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="SBUx_IDE7_JSON2">
					<div class="sbt-con-wrap">
						<div class="sbt-grid-wrap">
							<div class="sbt-wrap-header text-right body-18">
								(단위: 원)
							</div>
							<div class="wholesale-price-cont__sot">
								<div class="sot__top">
									<div class="top__left">
										<div class="left__item">품목</div>
									</div>
									<div class="top__right">
										<div class="right__item">단위</div>
										<div class="right__item">가격</div>
										<div class="right__item">등락률</div>
										<div class="right__item">전일</div>
										<div class="right__item">1개월전</div>
										<div class="right__item">1년전</div>
									</div>
								</div>
								<div class="sot__bot market_price_body">
									
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="SBUx_IDE8_JSON2">
					<div class="sbt-con-wrap">
						<div class="sbt-grid-wrap">
							<div class="sbt-wrap-header text-right body-18">
								(단위: 원)
							</div>
							<div class="wholesale-price-cont__sot">
								<div class="sot__top">
									<div class="top__left">
										<div class="left__item">품목</div>
									</div>
									<div class="top__right">
										<div class="right__item">단위</div>
										<div class="right__item">가격</div>
										<div class="right__item">등락률</div>
										<div class="right__item">전일</div>
										<div class="right__item">1개월전</div>
										<div class="right__item">1년전</div>
									</div>
								</div>
								<div class="sot__bot market_price_body">
									
								</div>
							</div>
						</div>
					</div>
				</div>
				<div id="SBUx_IDE9_JSON2">
					<div class="sbt-con-wrap">
						<div class="sbt-grid-wrap">
							<div class="sbt-wrap-header text-right body-18">
								(단위: 원)
							</div>

							<div class="wholesale-price-cont__sot">
								<div class="sot__top">
									<div class="top__left">
										<div class="left__item">품목</div>
									</div>
									<div class="top__right">
										<div class="right__item">단위</div>
										<div class="right__item">가격</div>
										<div class="right__item">등락률</div>
										<div class="right__item">전일</div>
										<div class="right__item">1개월전</div>
										<div class="right__item">1년전</div>
									</div>
								</div>
								<div class="sot__bot market_price_body">
									
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</section> -->
<!-- 거래상품 -->
<section class=" trading-wrap ">
	<div class="container-wrap trading-area">
		<h2 class="title-48-m">농산물 온라인도매시장 거래상품</h2>
		<script>
			var tabJsonData3 = [
				{ "id": "0", "pid": "-1", "order": "1", "text": "정가거래", "targetid": "SBUx_JS_JSON3", "targetvalue": "SBUX 탭" },
				{ "id": "1", "pid": "-1", "order": "2", "text": "입찰거래", "targetid": "SBUx_IDE_JSON3", "targetvalue": "SBUX IDE탭" },
				{ "id": "2", "pid": "-1", "order": "3", "text": "역입찰", "targetid": "SBUx_IDE1_JSON3", "targetvalue": "SBUX IDE탭" },
			];
		</script>
		<sbux-tabs uitype="normal" class="tab_round" jsondata-ref="tabJsonData3" callback-after-select="scwin.fnGetDmList">
		</sbux-tabs>

		<div class="tab-content">
			<div id="SBUx_JS_JSON3">
				<ul class="d-flex" id="item_list01">
				</ul>
			</div>
			<div id="SBUx_IDE_JSON3">
				<ul class="d-flex" id="item_list02">
				 </ul>
			</div>
			<div id="SBUx_IDE1_JSON3">
				<ul class="d-flex" id="item_list03">
				 </ul>
			</div>
		</div>
	</div>
</section>
<div id="dvSign">
	<script type="text/javascript">
		var i = 0; 
		var options = {"Width": "50%", "Height": "10px", DisableAlertMessage: {
               DisableDeleteConfirm: "1" // "1"로 설정시 파일 삭제시 confirm창 비활성.
               	}, MultiFileSelect: '0',
                   DisableMultiFileSelectInMobile: '1'};
			options["creationComplete"] = function() {
				//console.log("첨부파일 화면 로드 후");
				$("#dvSign").hide();
			};
			options["afterAddFile"] = function(uploadID, paramObj) {
				//console.log("파일 선택 후");
				var customValue = document.getElementById("hidden_customvalue").value;
				
	            RAONKUPLOAD.SetFileCustomValue(-1, customValue, uploadID); // 첫 번째 파라미터가 "-1"이면 현재 추가된 파일에 customValue를 부여함.

	            // 버튼 옆에 텍스트 영역에 현재 추가된 파일명을 보여줌.
                SBUxMethod.set(customValue, paramObj.strName);;
			};
			
			
			options["beforeUpload"] = function() {
				//console.log("파일 서버 전송 전")
			};
			
			
			// 파일 추가 전 이벤트
			options["beforeAddFile"] = function(uploadID, paramObj) {
                var targetCustomValue = document.getElementById("hidden_customvalue").value;
	            var allListArray = RAONKUPLOAD.GetListInfo("array", uploadID);
	            var targetOrder = null;
	            
            	scwin.addFileNm[scvar.clickIdx*1] = targetCustomValue;
	            
                var idx = 0;
                document.querySelectorAll('ul#jdgmtul input[type=text]').forEach( r => {
                	if(r.id == targetCustomValue) {
                		targetOrder = idx;
                		return;
                	}
            		else 	idx++
            	} );
				
				var newListArrayLen = allListArray.mergeFile.length;
				for (var i = 0; i < newListArrayLen; i++) {
				    if (allListArray.mergeFile[i].isWebFile=='1'
				    		&& allListArray.mergeFile[i].customValue==''
				    		&& document.getElementById('multiFile'+targetOrder)?.innerText!=''
				    		&& allListArray.mergeFile[i].originalName==document.getElementById('multiFile'+targetOrder)?.innerText) {
				        targetOrder = allListArray.mergeFile[i].order;
				        
	                    RAONKUPLOAD.SetSelectFile(targetOrder, '0', uploadID);
	                    RAONKUPLOAD.DeleteSelectedFile(uploadID);
	                    
	                    document.getElementById('multiFile'+(scvar.clickIdx*1)).innerText = '';

				        break;
				    }
				    else if (allListArray.mergeFile[i].isWebFile!='1'
			    				&& allListArray.mergeFile[i].customValue == targetCustomValue) {
				        targetOrder = i;
				        
	                    RAONKUPLOAD.SetSelectFile(targetOrder, '0', uploadID);
	                    RAONKUPLOAD.DeleteSelectedFile(uploadID);
	                    
				        break;
				    }
				}
				
                if (targetOrder != null) {
                    SBUxMethod.set(targetCustomValue, '');
                }
	            
	            return true;
			};
			options["uploadComplete"] = function(uploadID) {
				//console.log("파일 서버 전송 후")
				var dataArray = RAONKUPLOAD.GetListInfo('array', uploadID);

	            // 신규 업로드된 파일
	            var arrayNew = dataArray.newFile;
	            
	         // 삭제된 파일
	            var arrayDel = dataArray.deleteFile;
	            
	        	scwin.regBasicInfo(); 
	            	
			};
			
			common.createFileUpload("multiFile", options).then(function(obj) {
				scvar.multiFile = obj.ID;
			});
			
	</script>
</div>
