<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TeamAddUpdate.aspx.cs" Inherits="MainProject.SitesTeam.TeamAddUpdate" %>

<%@ Register Src="~/Components/HomeBar.ascx" TagPrefix="uc1" TagName="HomeBar" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Postavke tima</title>
    <link href="../Content/bootstrap.css" rel="stylesheet" />
    <link href="../Style/AddUpdatePage.css" rel="stylesheet" />
    <link href="../Style/HomeLink.css" rel="stylesheet" />
    <script src="../Scripts/bootstrap.js"></script>
    <script src="../Scripts/jquery-3.5.0.js"></script>
    <script src="../Scripts/popper.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <uc1:HomeBar runat="server" ID="HomeBar" />
        <div class="container-fluid">
            <div class="row">
                <div class="col-lg-6 col-md-12 input-col">
                    <div class="custom-col">
                        <h1 class="page-title">Postavke timova</h1>
                        <div class="form-group">
                            <span class="span-label">Naziv tima</span>
                            <asp:RequiredFieldValidator ID="ValidateName" runat="server" ValidationGroup="TeamValidation" ControlToValidate="txtTeamName" ErrorMessage="*" ForeColor="Red" Font-Size="1.5em"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtTeamName" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <span class="span-label">Voditelj tima</span>
                            <asp:RequiredFieldValidator ID="ValidateLeader" runat="server" ValidationGroup="TeamValidation" ControlToValidate="txtTeamLeader" ErrorMessage="*" ForeColor="Red" Font-Size="1.5em"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtTeamLeader" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <span class="span-label">Zaposleni u timu</span>
                            <asp:RequiredFieldValidator ID="ValidateEmployees" runat="server" ValidationGroup="TeamValidation" ControlToValidate="txaEmployees" ErrorMessage="*" ForeColor="Red" Font-Size="1.5em"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txaEmployees" runat="server" TextMode="MultiLine" Rows="8" Columns="20" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="row">
                            <div class="col-6">
                                <asp:Button ID="btnUpdate" runat="server" Text="Ažuriraj tim" OnClick="btnUpdate_Click" ValidationGroup="TeamValidation" CssClass="btn btn-primary btn-update" />
                            </div>
                            <div class="col-6">
                                <asp:Button ID="btnAdd" runat="server" Text="Dodaj tim" OnClick="btnAdd_Click" ValidationGroup="TeamValidation" CssClass="btn btn-primary btn-add" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 col-md-12">
                    <asp:GridView ID="Teams" runat="server" AllowSorting="true" AutoGenerateColumns="false" CssClass="gridView">
                        <Columns>
                            <asp:BoundField DataField="IDTeam" HeaderText="ID" ReadOnly="true" SortExpression="IDTeam" HeaderStyle-CssClass="id-col" />
                            <asp:BoundField DataField="Title" HeaderText="Naziv" ReadOnly="true" SortExpression="Title" />
                            <asp:TemplateField HeaderStyle-CssClass="select-col">
                                <ItemTemplate>
                                    <asp:Button ID="btnSelect" runat="server" CssClass="btn btn-primary btn-select" OnClick="btnSelect_Click" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
