<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<MyTodo.WebUx.Models.TaskList>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">myTODO</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>myTODO Lists</h2>
    
    <% foreach (var item in Model) { %>
        
        <ul>
            <li><%=Html.ActionLink(item.Name, item.ListId, "Get")%></li>
        </ul>
        
    <% } %>

    <div>
    <% if (User.IsInRole("Owner"))
       { %>
    <p>
           <% using (Html.BeginForm("CreateList", "Task"))
              { %>
                <%=Html.TextBox("Name", "New List Name")%><br />
                <%= Html.CheckBox("IsPublic", true)%> Share this TODO List?
           <% } %>
    </p>
    <% }
       else
       { %>
        <span><%=Html.ActionLink("Log On", "LogOn", "Account") %> to create new lists</span>
    <% } %>
    </div>
    
</asp:Content>

