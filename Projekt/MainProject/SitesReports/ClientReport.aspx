<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ClientReport.aspx.cs" Inherits="MainProject.SitesReports.ClientReport" %>

<%@ Register Src="~/Components/HomeBar.ascx" TagPrefix="uc1" TagName="HomeBar" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Izvješća za klijente</title>
    <link href="../Style/AddUpdatePage.css" rel="stylesheet" />
    <link href="../Style/Reports.css" rel="stylesheet" />
    <link href="../Style/HomeLink.css" rel="stylesheet" />
    <link href="../Content/bootstrap.css" rel="stylesheet" />
    <script src="../Scripts/jquery-3.5.0.js"></script>
    <script src="../Scripts/bootstrap.js"></script>
    <script src="../Scripts/popper.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <uc1:HomeBar runat="server" ID="HomeBar" />
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-6 col-md-12">
                    <h1 class="main-title left-title">Izvještaji za klijente</h1>
                    <asp:GridView ID="Projects" runat="server" AllowSorting="false" AutoGenerateColumns="false" CssClass="gridView">
                        <Columns>
                            <asp:BoundField DataField="ActivityName" HeaderText="Projekt" ReadOnly="true" />
                            <asp:BoundField DataField="DurationInMinutes" HeaderText="Vrijeme u minutama" ReadOnly="true" />
                        </Columns>
                    </asp:GridView>
                </div>
                <div class="col-lg-6 col-md-12">
                    <h1 class="main-title">Klijenti</h1>
                    <asp:GridView ID="Clients" runat="server" AutoGenerateColumns="false" CssClass="gridView">
                        <Columns>
                            <asp:BoundField DataField="IDClient" HeaderText="ID" ReadOnly="true" HeaderStyle-CssClass="id-col" />
                            <asp:BoundField DataField="Title" HeaderText="Naziv" ReadOnly="true" />
                            <asp:TemplateField HeaderStyle-CssClass="select-col">
                                <ItemTemplate>
                                    <asp:Button ID="btnSelect" runat="server" CssClass="btn btn-primary btn-select" OnClick="btnSelect_Click" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <span class="span-label">Ime datoteke:</span>
                    <asp:TextBox ID="txtFileName" runat="server" CssClass="form-control"/>
                    <asp:Button ID="btnExport" Text="Izvoz" OnClick="btnExport_Click" runat="server" CssClass="btn btn-primary btn-export"/>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
