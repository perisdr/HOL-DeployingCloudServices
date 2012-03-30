<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="loginTitle" ContentPlaceHolderID="TitleContent" runat="server">myTODO - Log On</asp:Content>

<asp:Content ID="loginContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="infoBox">
        <h2>Log On</h2>
        <p></p>
    </div>
    
    <%= Html.ValidationSummary("Login was unsuccessful. Please correct the errors and try again.") %>

    <% using (Html.BeginForm()) { %>
        <div class="form">
            <p>
                Please enter your username and password.
            </p>
            <p>
                <label for="username">Username:</label><br />
                <%= Html.TextBox("username") %>
                <%= Html.ValidationMessage("username") %>
            </p>
            <p>
                <label for="password">Password:</label><br />
                <%= Html.Password("password") %>
                <%= Html.ValidationMessage("password") %>
            </p>
            <p>
                <%= Html.CheckBox("rememberMe") %> <label class="inline" for="rememberMe">Remember me?</label>
            </p>
            <div class="submit">
                <input type="submit" value="Log On »" />
            </div>            
        </div>
    <% } %>
</asp:Content>
