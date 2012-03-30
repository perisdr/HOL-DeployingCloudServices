<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">myTODO - Welcome</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="welcome">
        <h2>Welcome!</h2>
        <p>
            Before you start using myTODO you need to prepare the application for the first time
        </p>        
        <%= Html.ActionLink("Start", "Register", "Account") %>               
    </div>
</asp:Content>

<asp:Content ContentPlaceHolderID="ToolbarContent" runat="server"></asp:Content>