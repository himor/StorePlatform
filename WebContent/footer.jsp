<%--
	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	Footer Module
--%>

		</div>
	</div>
	
	<!-- footer -->
	<div id="header-line"></div>		
	<div id="footer1">
		<div id="btm-content" class="texts">
		Copyright &copy Mike Gordo 2013 <a href="mailto:himor.cre@gmail.com">himor.cre@gmail.com</a>
		</div>
	</div>	

<script>
$(window).load(function(){
	$("#sidebar").height($("#content").height());
});

$(document).ready(function(){
	$("#search-holder").wrapAll("<form method='get' id='search-form' action='search.jsp'>");
	$("#search-text").bind("keypress", function(e) {
        if (e.keyCode == 13) {
			$("#search-form").submit();
            return false;
        }
    });
	<% if (!sess_uid.equals("0")) { %>
		setInterval(function() {
			checkNotif();	
		}, 5000);
		
		function checkNotif() {
			$.post('slave.jsp', {action:1}, function(data) {
				$('#notif').html(data);
			});	
		}
		checkNotif();
	<% } %>

});
</script>

</div>
</body>
</html>
