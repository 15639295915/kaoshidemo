<%@ page isELIgnored="false" contentType="text/html;UTF-8" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'index.jsp' starting page</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	-->
	
	<!-- 需要引入jquery脚本库以及easyUI脚本库；而且这两个js文件必须有上下顺序 -->
	<script type="text/javascript" src="${pageContext.request.contextPath }/js/jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath }/js/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath }/js/easyui-lang-zh_CN.js"></script>
	
	<!-- 还需要引入两个css文件 -->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/themes/default/easyui.css">
	
	<script type="text/javascript">
		$(function(){
			$("#studentDatagrid").datagrid({
				url:"getStudentByPage.do",
				pagination:true,
				pageSize:10,
				pageList:[10,20,30,40],
				/* rowStyler:function(i,r){
					if(r.stu_age==null){
						return "background-color:blue";
					}
				}, */
				columns:[[
					//一个{}表示的就是一列
					{checkbox:true},
					{title:"编号",field:"stu_id"},
					{
						title:"姓名",
						field:"stu_name",
						/* styler:function(value,rowData,rowIndex){
							if(value==1){
								return "color:red;background-color:green";
							}
						} */
					},
					{title:"年纪",field:"stu_age"},
					{title:"性别",field:"stu_gender",
						formatter:function(value,rowData,rowIndex){
							//return的值经过浏览器解析处理显示在页面上
							if(value==0){
								return "女";
							}else{
								return "男";
							}
						}
					},
					{
						title:"操作",field:"cz",
						
						//value:值，属性获取到的值
						//rowData:行对象；一个js对象
						//rowIndex:行索引；行号
						formatter:function(value,rowData,rowIndex){
							//return的值经过浏览器解析处理显示在页面上
							return "<a href='javascrip:void(0)' onclick='toGetOne("+rowData.stu_id+")'>修改</a>"
						}
					}
				]],
				title:"学生列表",
				width:400,
				iconCls:"icon-search",
				toolbar:"#studentToolbar",
				//singleSelect:true,//只允许单选
				
				onDblClickRow:function(rowIndex,rowData){
					//console.log(rowData);
					//把数据写入到修改对话框中，然后把修改对话框打开
					//1.把要修改的数据，填入到修改对话框中
					$("#updateId").val(rowData.stu_id);
					$("#updateName").val(rowData.stu_name);
					$("#updateAge").val(rowData.stu_age);
					
					//2.把修改对话框打开
					$("#updateDialog").dialog("open");
					
				}
			});
			$("#updateDialog").dialog({
				title:"修改对话框",
				width:280,
				height:150,
				closed:true
			});
			$("#insertDialog").dialog({
				title:"添加对话框",
				width:280,
				height:150,
				closed:true
			});
		});
		
		function searchStudent(){
			var stu_name=$("#stu_name").val();
			alert(stu_name);
			//调用load/reload方法完成
			$("#studentDatagrid").datagrid("reload",{"stu_name":stu_name});
		}
		
		function toOpenUpdateDialog(){
			//alert(0)
			//获取到选中的行的内容
			//通过getSelected方法获取到选中的行
			var selectedRow = $("#studentDatagrid").datagrid("getSelected");
			if(selectedRow==null){
				alert("请先选中要修改的内容");
			}else{
				console.log(selectedRow);
				//
			}
		}
		
		function toOpenInsertDialog(){
			//alert(0)
			//获取到选中的行的内容
			//通过getSelected方法获取到选中的行
				$("#insertDialog").dialog("open");
		}
		
		function toGetOne(id){
			//alert(id)
			//发送ajax请求都后台，根据id获取到一个user对象，
			//然后再把user中的内容写入到修改对话框中
		}
		function doUpdate(){
				//1.通过form控件的submit方法完成修改数据的提交
				$("#updateForm").form("submit",{
					url:"update.do",
					success:function(data){
						//2.当后台响应回来数据时，做处理：
						//修改成功，需要把修改对话框关闭掉；刷新datagrid
						//alert(data+"******后台响应回来的数据")
						if(data){
							alert("修改成功");
							$("#updateDialog").dialog("close");
							$("#studentDatagrid").datagrid("reload");
						}else{
							alert("修改失败");
						}
						
					}
				});
				
			}
			function doInsert(){
				//1.通过form控件的submit方法完成修改数据的提交
				$("#insertForm").form("submit",{
					url:"insert.do",
					success:function(data){
						//2.当后台响应回来数据时，做处理：
						//修改成功，需要把修改对话框关闭掉；刷新datagrid
						//alert(data+"******后台响应回来的数据")
						if(data){
							alert("添加成功");
							$("#insertDialog").dialog("close");
							$("#studentDatagrid").datagrid("reload");
						}else{
							alert("添加失败");
						}
						
					}
				});
				
			}
		function doMultiDelete(){
		//alert(0)
		//1.获取到所有选中的行：通过datagrid的getSelections方法获取到
		var allSelectedRows = $("#studentDatagrid").datagrid("getSelections");
		if(allSelectedRows.length==0){
			//alert("请选中要删除的数据");
			$.messager.alert("提示框","请选中要删除的数据","warning");
		}else{
			//确认是否删除
			//var isConfirm = confirm("确认真的要删除选中的内容吗？");
			$.messager.confirm("确认框","确认真的要删除选中的内容吗？",function(result){
				//alert(result+"resulttttttttttttttttttttt");
				if(result){
					//alert(0);
					//执行删除操作
					//alert("执行删除操作");
					//1.获取到所有选中的id
					var ids = new Array(allSelectedRows.length);
					for(var i=0;i<allSelectedRows.length;i++){
						ids[i]=allSelectedRows[i].stu_id;
					}
					
					//2.发送ajax请求到后台，执行删除操作
					$.ajax({
						url:"multiDelete.do",
						//data:"ids="+ids,
						
						data:{"ids":ids},//这样写发送到后台的参数名是ids[]
						//在使用json格式的数据作为参数往后台传递的时候，
						//数组数据会被jquery做进一步的处理===>key[]作为发送到后台的参数名
						//jquery的深度序列化
						
						//不让jquery做深度序列化
						traditional:true,
						 
						success:function(data){
							//alert(data);
							if(data){
								//alert("删除成功");
								$.messager.show({
									title:"删除提示",
									msg:"删除成功",
									showSpeed:5000,
									showType:"fade"
								});
								$("#studentDatagrid").datagrid("reload");
							}else{
								alert("删除失败");
							}
						}
					});
					
				}
			
			});
		}
		
	}
	</script>
	
  </head>
  
  <body>
  	<form id="studentDatagrid"></form>
  	<div id="studentToolbar">
	  	用户名：<input id="stu_name"/><input type="button" onclick="searchStudent()" value="搜索"/><br/>
  		<a href="JavaScript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="toOpenInsertDialog()">添加</a>
  		<a href="JavaScript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="toOpenUpdateDialog()">修改</a>
  		<a href="JavaScript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="doMultiDelete()">批量删除</a>
  	</div>
  	
  	<div id="updateDialog">
  		<form id="updateForm" method="post">
  			<input type="hidden" name="stu_id" id="updateId"/>
  			学生姓名:<input name="stu_name" id="updateName"/><br/>
  			学生年纪:<input name="stu_age"  id="updateAge"/><br/>
	  		<a href="JavaScript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="doUpdate()">修改</a>
  			<!-- <input type="button" value="修改"/> -->
  		</form>
  	</div>
  	
  	<div id="insertDialog">
  		<form id="insertForm" method="post">
  			学生姓名:<input name="stu_name" id="insertName"/><br/>
  			学生年纪:<input name="stu_age"  id="insertAge"/><br/>
  			学生性别:<input type="radio" value="1" checked="checked" name="stu_gender"/>男
  			<input type="radio" value="0" name="stu_gender"/>女<br/>
	  		<a href="JavaScript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="doInsert()">增加</a>
  		</form>
  	</div>
  </body>
</html>


