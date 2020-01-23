<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>IEngage Text Analysis</title>
<link href="https://fonts.googleapis.com/css?family=Lato&display=swap" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.3.2/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/2.3.2/css/bootstrap.min.css">
<style>
	textarea {
		resize:none;
		width:80%;
		font-family: Lato !important;
		
	}
	
	textarea::placeholder {
		color:black;
	}

	#myBar {
	  width: 1%;
	  height: 20px;
	  background-color: #3e4a7a;
	}
	
	#text-analyze:hover{
		background: black;
		color:white;
	}
	#tags{
		font-size: 1rem;
	}
	
	#tag-header{
		
	}
	@-webkit-keyframes example {
	from {width:0px;color:lightgreen;font-size:0px;}
		to {width:150px;color:black;font-size:0px;}
	}
	
	.loader {
		border: 5px solid #f3f3f3;
		border-radius: 50%;
		border-top: 5px solid #3498db;
		  width: 15px;
		  height: 15px;
		  -webkit-animation: spin 2s linear infinite; /* Safari */
		  animation: spin 0.5s linear infinite;
		  display:none;
		  border-bottom:5px solid black;
	}

	@keyframes spin {
		0% { transform: rotate(0deg); }
		100% { transform: rotate(180deg);
	}
	
	.btn{
		width:6rem;
		font-size:1rem;
		cursor:pointer;
	}
</style>
</head>

<body>
<br>
<br>
<div style="background:white;color:white;font-family: Lato !important;">
	<div style="padding-left:20px">
		<span><h3 style="color:black">Enter your text....</h3></span>
		<textarea rows="5" cols="100" style="width:90%;background:transparent;color:black;border:1px solid grey;border-radius: 2px;" autofocus id="input-text" placeholder="Please write something...."></textarea>
	</div>
	<br>
	<!-- <div id="myProgress" style="display:none;text-align:left;margin-left:20px"> 
	  <div id="myBar" style="width:500px;"></div>
	  <div id="status" ></div>
	</div> -->
	<br>
	<div style="padding-left:20px;padding-bottom:20px">
		<div class="loader" style="display:none;"></div>
		<button id="text-analyze" style="    width: 8rem;
    display: block;
    height: 2.5rem;
    color: white;
    background: #052745;
    border-radius: 10px"><i class="fa fa-search"></i> Analyze</span></button>
	</div>
	<div id="sidebar" style="display:none;margin-left:20px;width:100%;text-align:center;" class="row">
		<div id="tag-header" style="padding-left:5px;color:black;" class="span6">
			<span>
				<h4 style="color:black;">Tags</h4>
			</span>
			<div id="tag-areas" style="padding-bottom:20px;display:block;"></div>
		</div>
		<div id="sentiment-header" style="padding-left:5px;color:black;" class="span6">
			<span>
				<h4 style="color:black;">Sentiments</h4>
			</span>
			<div id="sentiment-areas" style="padding-bottom:20px;display:block;"></div>
		</div>
		<!--  <div id="classification-header" style="padding-left:5px;color:black;" class="span3">
			<span>
				<h4 style="color:black;">Classification</h4>
			</span>
			<div id="classification-areas" style="padding-bottom:20px;display:block;"></div>
		</div>
	-->
		<div id="type-header" style="padding-left:5px;color:black;" class="span6">
			<span>
				<h4 style="color:black;">Type</h4>
			</span>
			<div id="type-areas" style="padding-bottom:20px;display:block;"></div>
		</div>
	</div>
</div>
<script>
$(document).ready(function(){
	$('#text-analyze').click(function(e){
		e.preventDefault();
		/*move();*/
		$('#sidebar').css('display','none');
		var enteredInput = $('#input-text').val();
		if(enteredInput.length==0){
			alert('You need to enter something....');
		}
		else{
			$('#text-analyze').css('display','none');
			$('.loader').css('display','block');
			getTags(enteredInput);
		}
	});
	$('#input-text').keydown(function(event){
		if (event.keyCode === 13 && !event.shiftKey) {
			event.preventDefault();
			$("#text-analyze").click();
		}
	});
});

function getTags(inputText){
	$.ajax({
		url:'textanalysis',
		method: 'POST',
		data: {
				requestParameter:'getTags',
				text:inputText
			},
		success:function(data){
			x=data;
			data = JSON.parse(data);
			extractData(data);
			
		}
	});	

}

function extractData(response){
	tags =[];
	$('#tag-areas').empty();
	$('#sentiment-areas').empty();
	$('#classification-areas').empty();
	$('#type-areas').empty();
	$('#sidebar').css("display","block");
	if(response.tags=='NOT_FOUND' || response.tags.length==0){
		$('#tag-areas').html('NO TAGS');
	}else{
		for(i=0;i<response.tags.length;i++){
			var c = pickColor();
			var r= $('<button type="button" id="tags" class="btn" style="border-radius:20px;cursor:default;background:'+pickColor()+';color:white;" >'+response.tags[i]+'</button>');
			$('#tag-areas').append(r);
			$('#tag-areas').append('\t\t');
		}
	}
	if(response.sentiment=='NOT_FOUND'){
		$('#sentiment-areas').html('NO SENTIMENT');
	}else{
		if(response.sentiment==0.0){
			sentimentValue = 'Neutral';
			sentimentColor = '#545454';
		}
		if(response.sentiment>0.0){
			sentimentValue = 'Positive';
			sentimentColor = '#419600';
		}
		if(response.sentiment<0.0){
			sentimentValue = 'Negative';
			sentimentColor = '#ff0808'
		}
		$('#sentiment-areas').html("<span style='font-size:16px;color:"+sentimentColor+";'><b>"+sentimentValue+" : "+response.sentiment+"</b></span>");
	}
	/*if(response.classification=='NOT_FOUND' || response.classification.length==0){
		$('#classification-areas').html('NO CLASSIFICATION');
	}else{
		for(i=0;i<response.classification.length;i++){
			name = response.classification[i].name;
			confidence = Number(response.classification[i].confidence).toFixed(3);
			var r= $('<button type="button" id="classification" class="btn" style="border-radius:20px;cursor:default;background:#620808f7;color:white;" >'+name+'\n'+confidence+'</button>');
			$('#classification-areas').append(r);
		}
	}*/
	if(response.types=='NOT_FOUND'){
		$('#type-areas').html('NO TYPE');
	}else{
		var a;
		if(response.types.appreciation!=0.0){
			a= $('<button type="button" id="type" class="btn" style="border-radius:20px;background:#12718f;cursor:default;color:white;" >Appreciation </button>');
			$('#type-areas').append(a);
			$('#type-areas').append('\n');
		}
		if(response.types.comment!=0.0){
			a= $('<button type="button" id="type" class="btn" style="border-radius:20px;background:#12718f;cursor:default;color:white;" >Comment </button>');
			$('#type-areas').append(a);
			$('#type-areas').append('\n');
		}
		if(response.types.complaint!=0.0){
				a = $('<button type="button" id="type" class="btn" style="border-radius:20px;background:#12718f;cursor:default;color:white;" >Complaint </button>');
			$('#type-areas').append(a);
			$('#type-areas').append('\n');
		}
		if(response.types.suggestion!=0.0){
			a = $('<button type="button" id="type" class="btn" style="border-radius:20px;background:#12718f;cursor:default;color:white;" >Suggestion </button>');
					$('#type-areas').append(a);
			$('#type-areas').append('\n');
		}
		if(response.types.question!=0.0){
			a = $('<button type="button" id="type" class="btn" style="border-radius:20px;background:#12718f;cursor:default;color:white;" >Question </button>');
					$('#type-areas').append(a);
			$('#type-areas').append('\n');
		}

	}
	$('#text-analyze').css('display','block');
	$('.loader').css('display','none');
	$('#tag-header').css('display','block');
}

function pickColor(){
	var r = (Math.random()*200).toFixed(0);
	var g = (Math.random()*150).toFixed(0);
	var b = (Math.random()*50).toFixed(0);
	
	r = Number(r).toString(16);
	if(r.length==1){
		r = "0"+r;
	}
	g = Number(g).toString(16);
	if(g.length==1){
		g = "0"+g;
	}
	b = Number(b).toString(16);
	if(b.length==1){
		b = "0"+b;
	}
	
	return "#"+r+g+b;
}
	
	
	

</script>
	
</body>
</html>



