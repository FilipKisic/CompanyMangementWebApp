﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ClientSelectDeactivate.aspx.cs" Inherits="MainProject.SitesClient.ClientSelectDeactivate"%>

<%@ Register Src="~/Components/Footer.ascx" TagPrefix="uc1" TagName="Footer" %>
<%@ Register Src="~/Components/HomeBar.ascx" TagPrefix="uc1" TagName="HomeBar" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Klijenti</title>
    <link href="../Content/bootstrap.css" rel="stylesheet" />
    <link href="../Style/SelectDeactivatePage.css" rel="stylesheet" />
    <link href="../Style/HomeLink.css" rel="stylesheet" />
    <script src="../Scripts/jquery-3.5.0.js"></script>
    <script src="../Scripts/bootstrap.js"></script>
    <script src="../Scripts/popper.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <uc1:HomeBar runat="server" ID="HomeBar" />
        <div class="container-fluid">
            <div class="row">
                <div class="col-12 greeting">
                    <h1 runat="server" id="title">Pregled klijenata</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <asp:GridView ID="Clients" runat="server" AllowSorting="true" AutoGenerateColumns="false" DataSourceID="GridDataSource" CssClass="gridView">
                        <Columns>
                            <asp:BoundField DataField="IDClient" HeaderText="ID" ReadOnly="true" SortExpression="IDClient" HeaderStyle-CssClass="id-col" />
                            <asp:BoundField DataField="Title" HeaderText="Naziv" ReadOnly="true" SortExpression="Title" />
                            <asp:BoundField DataField="IsActive" HeaderText="Aktivan" ReadOnly="true" SortExpression="IsActive" />
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:Button ID="btnSelect" runat="server" Text="Deaktiviraj" CssClass="btn btn-primary btn-select" OnClick="btnSelect_Click"/>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:SqlDataSource ID="GridDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:cs %>"
                        SelectCommand="spSelectClients" SelectCommandType="StoredProcedure" />
                </div>
            </div>
        </div>
        <uc1:Footer runat="server" ID="Footer" />
    </form>
</body>
</html>
