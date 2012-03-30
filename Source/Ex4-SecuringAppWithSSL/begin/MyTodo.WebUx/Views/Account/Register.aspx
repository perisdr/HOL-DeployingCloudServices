<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="registerTitle" ContentPlaceHolderID="TitleContent" runat="server">myTODO - Register</asp:Content>

<asp:Content ID="registerContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="infoBox">
        <h2>
            Create a New Account</h2>
        <p>
            Use the form below to create a new account.
        </p>
    </div>
    <%= Html.ValidationSummary("Account creation was unsuccessful. Please correct the errors and try again.") %>
    <% using (Html.BeginForm())
       { %>
    <div class="form">
        <p>
            <label for="username">
                Choose a username<br />
                <span>No spaces or special characters are allowed.</span>
            </label>
            <br />
            <%= Html.TextBox("username") %>
            <%= Html.ValidationMessage("username") %>
        </p>
        <p>
            <label for="email">
                What's your email address:
            </label>
            <br />
            <%= Html.TextBox("email") %>
            <%= Html.ValidationMessage("email") %>
        </p>
        <p>
            <label for="password">
                Pick a Password<br />
                <span>Passwords are required to be a minimum of
                    <%=Html.Encode(ViewData["PasswordLength"])%>
                    characters in length.</span>
            </label>
            <br />
            <%= Html.Password("password") %>
            <%= Html.ValidationMessage("password") %>
        </p>
        <p>
            <label for="confirmPassword">
                Confirm your password<br />
                <span>Type the password again. Just to confirm.</span>
            </label>
            <br />
            <%= Html.Password("confirmPassword") %>
            <%= Html.ValidationMessage("confirmPassword") %>
        </p>      
        <div class="submit">
            <input type="submit" value="Register »" />
        </div>
    </div>
    <% } %>
</asp:Content>
