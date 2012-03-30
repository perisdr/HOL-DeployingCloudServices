﻿<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="changePasswordTitle" ContentPlaceHolderID="TitleContent" runat="server">myTODO - Profile</asp:Content>

<asp:Content ID="changePasswordContent" ContentPlaceHolderID="MainContent" runat="server">
     <div class="infoBox">
        <h2>Update Profile</h2>
        <p>
            Use the form below to update your account information.
        </p>
    </div>
      <%= Html.ValidationSummary("Profile update was unsuccessful. Please correct the errors and try again.") %>
    <% using (Html.BeginForm())
       { %>
    <div class="form">
        <p>
            <label for="currentPassword">
                Enter your current password<br />
                 <span>Leave this field in blank if you don’t want to update your password.</span>
            </label>
            <br />
            <%= Html.Password("currentPassword")%>
        </p>
        <div id="newPasswordFields">
        <p>
            <label for="newPassword">
                Pick a new password<br />
             <span>Passwords are required to be a minimum of
                    <%=Html.Encode(ViewData["PasswordLength"])%>
                    characters in length.</span>
            </label>
            <br />
            <%= Html.Password("newPassword")%>
            <%= Html.ValidationMessage("newPassword")%>
        </p>
        <p>
            <label for="confirmPassword">
                Confirm your new password<br />
                <span>Type the password again. Just to confirm.</span>
            </label>
            <br />
            <%= Html.Password("confirmPassword") %>
            <%= Html.ValidationMessage("confirmPassword") %>
        </p>
        </div>        
        <div class="submit">
            <input type="submit" value="Update Profile »" />
        </div>
    </div>
    <% } %>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="ScriptsContent" runat="server">
    <script type="text/javascript" src="<%=Url.Content("~/Content/scripts/jquery-1.3.2.js")%>"></script>
    <script type="text/javascript">

        var checkHasPassword = function() {
            if ($('#currentPassword').val() == '') {
                $('#newPassword').attr("disabled", true);
                $('#confirmPassword').attr("disabled", true);
                $('#newPasswordFields').addClass("disabled");
            }
            else {
                $('#newPassword').attr("disabled", false);
                $('#confirmPassword').attr("disabled", false);
                $('#newPasswordFields').removeClass("disabled");
            }
        };

            $('#currentPassword').blur(checkHasPassword)
                         .keyup(checkHasPassword);

            $(document).ready(checkHasPassword);
            
    </script>
</asp:Content>
