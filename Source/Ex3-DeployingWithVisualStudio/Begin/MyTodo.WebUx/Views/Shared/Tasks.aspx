<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">myTODO - Tasks</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="listHeader">
        <h2>
            <span class="sep">(</span>
            <%=Html.ActionLink("RSS", "Rss", "Todo") %>            
            <span class="sep">)</span>
            <%=ViewData["ListName"]%>
        </h2>
    </div>
    <div id="loading">
        Loading Tasks...
    </div>
    <div id="tasksWrapper" style="display:none; clear: both;">
        <ul class="listTasks" id="tasks">
            <li class="empty">No tasks here.</li>
        </ul>
        <% if ((bool)ViewData["AuthenticatedUser"]) %>
        <% { %>
        <div id="newTask">
            <p>
                <input type="text" class="title" id="newTaskField" />
                <a id="newTaskBtn" class="btn add"><span>Add</span></a>
            </p>        
        </div>
        <% } %>
    </div>
    <div class="break"></div>
</asp:Content>

<asp:Content ContentPlaceHolderID="StylesContent" runat="server">
    <link type="text/css" rel="Stylesheet" href="<%=Url.Content("~/Content/styles/redmond/jquery-ui-1.7.2.custom.css") %>" />
</asp:Content>

<asp:Content ContentPlaceHolderID="ScriptsContent" runat="server">
    <script type="text/javascript" src="<%=Url.Content("~/Content/scripts/jquery-1.3.2.js")%>"></script>
    <script type="text/javascript" src="<%=Url.Content("~/Content/scripts/jquery-ui-1.7.2.custom.js")%>"></script>
    <script type="text/javascript" src="<%=Url.Content("~/Content/scripts/plugin.taskitem.js")%>"></script>
    <script type="text/javascript" src="<%=Url.Content("~/Content/scripts/page.tasks.js")%>"></script>
    <script type="text/javascript" src="<%=Url.Content("~/Content/scripts/jquery.checkbox.min.js")%>"></script>
    <script type="text/javascript" src="<%=Url.Content("~/Content/scripts/services.tasks.js")%>"></script>
    <script type="text/javascript">
    listId = "<%=ViewData["ListId"]%>";
    authenticatedUser = <%= (bool)ViewData["AuthenticatedUser"] ? "true" : "false" %>;
    tasksService = new TaskServiceProxy("<%=Url.Content("~/ToDo") %>");
    </script>
</asp:Content>
