<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%
    if (Request.IsAuthenticated) {
%>
        Welcome <b><%= Html.Encode(Page.User.Identity.Name) %></b>!
        |
        <%--<%= Html.ActionLink<AccountController>(c => c.Profile(), "Profile") %>--%>
        <%= Html.ActionLink("Profile", "Profile", "Account") %>
        |                
        <%= Html.ActionLink("Sign Out", "LogOff", "Account")%>                       
             <%--//Html.ActionLink<AccountController>(c => c.LogOff(), "Sign Out")%>--%>
<%
    }
    else {
%>      <%= Html.ActionLink("Sign In", "LogOn", "Account")%>
        <%--<%= Html.ActionLink<AccountController>(c => c.LogOn(), "Sign In") %>--%>
<%
    }
%>
