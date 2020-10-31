<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HomeBar.ascx.cs" Inherits="MainProject.Components.HomeBar" %>

<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarTogglerDemo01"
        aria-controls="navbarTogglerDemo01" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse justify-content-start" id="navbarTogglerDemo01">
        <asp:HyperLink ID="homeLink" runat="server" Text="&larr; Nazad" CssClass="home-link"></asp:HyperLink>
    </div>
</nav>