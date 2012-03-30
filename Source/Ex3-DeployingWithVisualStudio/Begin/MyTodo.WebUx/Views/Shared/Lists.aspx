<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ContentPlaceHolderID="TitleContent" runat="server">myTODO - Lists</asp:Content>

<asp:Content ContentPlaceHolderID="MainContent" runat="server">
    <div class="listHeader">
        <h2> 
            <span class="sep">(</span>
            <%=Html.ActionLink("RSS", "Rss", "Todo") %>
            <span class="sep">)</span>
            My Lists
        </h2>
    </div>
    <div id="loading">
        Loading Lists...
    </div>
    <div id="listsWrapper" style="display:none; clear: both;">
        <ul class="listTasks" id="lists">
            <li class="empty">No lists are available.</li>
        </ul>
        <% if ((bool)ViewData["AuthenticatedUser"]) %>
        <% { %>
        <div id="newList">
            <p>
                <input type="text" class="title" id="newListField" />
                <a id="newListBtn" class="btn add"><span>Add</span></a>
            </p>
        </div>
        <% } %>
    </div>
    <div class="break"></div>
</asp:Content>

<asp:Content ContentPlaceHolderID="ScriptsContent" runat="server">
    <script type="text/javascript" src="<%=Url.Content("~/Content/scripts/jquery-1.3.2.js")%>"></script>
    <script type="text/javascript" src="<%=Url.Content("~/Content/scripts/plugin.listitem.js")%>"></script>
    <script type="text/javascript" src="<%=Url.Content("~/Content/scripts/page.lists.js")%>"></script>
    
    <%--Service Proxy--%>
    <script type="text/javascript" src="<%=Url.Content("~/Content/scripts/services.lists.js")%>"></script>
    <script type="text/javascript">
    authenticatedUser = <%= (bool)ViewData["AuthenticatedUser"] ? "true" : "false" %>;
    listsService = new ListServiceProxy("<%=Url.Content("~/ToDo") %>");
    </script>
</asp:Content>
