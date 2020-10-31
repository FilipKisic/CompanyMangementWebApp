<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TeamReports.aspx.cs" Inherits="MainProject.SitesReports.TeamReports" %>

<%@ Register Src="~/Components/HomeBar.ascx" TagPrefix="uc1" TagName="HomeBar" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Izvještaji za timove</title>
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
                    <h1 class="main-title">Izvještaji za timove</h1>
                    <asp:GridView ID="Employees" runat="server" AllowSorting="false" AutoGenerateColumns="false" CssClass="gridView">
                        <Columns>
                            <asp:BoundField DataField="IDWorker" HeaderText="ID" ReadOnly="true" HeaderStyle-CssClass="id-col" />
                            <asp:BoundField DataField="FullName" HeaderText="Ime i prezime" ReadOnly="true" />
                            <asp:BoundField DataField="PersonalDurationInMinutes" HeaderText="Vrijeme u minutama" ReadOnly="true" />
                        </Columns>
                    </asp:GridView>
                </div>
                <div class="col-lg-6 col-md-12">
                    <h1 class="main-title">Timovi</h1>
                    <asp:GridView ID="Teams" runat="server" AllowSorting="false" AutoGenerateColumns="false" CssClass="gridView">
                        <Columns>
                            <asp:BoundField DataField="IDTeam" HeaderText="ID" ReadOnly="true" HeaderStyle-CssClass="id-col" />
                            <asp:BoundField DataField="Title" HeaderText="Naziv" ReadOnly="true" />
                            <asp:TemplateField HeaderStyle-CssClass="select-col">
                                <ItemTemplate>
                                    <asp:Button ID="btnSelect" runat="server" CssClass="btn btn-select" OnClick="btnSelect_Click" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <span class="span-label">Ime datoteke:</span>
                    <asp:TextBox ID="txtFileName" runat="server" CssClass="form-control"/>
                    <asp:Button ID="btnExport" Text="Izvoz" runat="server" OnClick="btnExport_Click" CssClass="btn btn-primary btn-export" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>
