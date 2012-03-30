<?xml version="1.0" encoding="utf-8"?>
<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<Feed>" ContentType="application/rss+xml" %>
<%@ Import Namespace="MyTodo.WebUx.Models"%>
<rss version="2.0" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <channel>
        <title><%=Html.Encode(ViewData.Model.Title) %></title>
        <description><%=ViewData.Model.Description %></description>
        <link><%=ViewData.Model.Url%></link>
        <language><%=ViewData.Model.Language%></language>
 
       <%foreach (FeedItem item in ViewData.Model.Items)
         {%>
        <item>
            <dc:creator><%=Html.Encode(item.Creator)%></dc:creator>
            <title><%=Html.Encode(item.Title)%></title>
            <description><%=Html.Encode(item.Description)%></description>
            <link><%=item.Url %></link>
            <pubDate><%=item.Published.ToString("R") %></pubDate>
            <% foreach (string tag in item.Tags)
               { %>
                <category><%=tag %></category>
            <% } %>
        </item>
        <%
          } %>
    </channel>
</rss>
