<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">myTODO - About</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="listHeader">
        <h2>About myTODO</h2>
        
    <p>
            myTODO is a Microsoft Developer &amp; Platform Evangelism sample application built on 
            Windows Azure to manage and share simple lists (e.g. tasks to complete, favorite movies, 
            books you enjoyed, etc.).
    </p>
                      
        <h3>About the sample</h3>
        <p>
            The application uses what in Windows Azure is called a Web Role. Web Roles are slices
            of web servers that you can use in order to host applications like ASP.NET, PHP,
            FAST-CGI, and WCF. You can get your own for testing visiting <a href="http://www.microsoft.com/azure/windowsazure.mspx">Windows Azure Developer
            Center</a>.
        </p>
    </div>
    <ul class="listTasks" id="about">
</asp:Content>
