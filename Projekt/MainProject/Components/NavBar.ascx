<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NavBar.ascx.cs" Inherits="MainProject.Components.NavBar" %>

<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarTogglerDemo01"
        aria-controls="navbarTogglerDemo01" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse justify-content-end" id="navbarTogglerDemo01">
        <asp:ImageButton ID="SettingsIcon" runat="server" CssClass="navbar-brand" OnClick="SettingsIcon_Click" ImageUrl="~/Icons/settings.svg" Height="50"/>
    </div>
</nav>
