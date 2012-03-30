<%@Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage" %>

<asp:Content ID="ProfileTitle" ContentPlaceHolderID="TitleContent" runat="server">myTODO - Profile</asp:Content>

<asp:Content ID="ProfileUpdateSuccessContent" ContentPlaceHolderID="MainContent" runat="server">
     <div class="listHeader">
        <h2>Profile Updated</h2>
    </div>
    <ul class="listTasks" id="about">
    <p>
        Your profile has been updated successfully.
    </p>
</asp:Content>
