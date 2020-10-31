<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProjectAddUpdate.aspx.cs" Inherits="MainProject.SitesProject.ProjectAddUpdate" %>

<%@ Register Src="~/Components/HomeBar.ascx" TagPrefix="uc1" TagName="HomeBar" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Postavke projekta</title>
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
                        <h1 class="page-title">Postavke projekta</h1>
                        <div class="form-group">
                            <span class="span-label">Naziv projekta</span>
                            <asp:RequiredFieldValidator ID="ValidateTitle" runat="server" ValidationGroup="ProjectValidation" ControlToValidate="txtProjectTitle" ErrorMessage="*" ForeColor="Red" Font-Size="1.5em"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtProjectTitle" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <span class="span-label">Klijent</span>
                            <asp:RequiredFieldValidator ID="ValidateClient" runat="server" ValidationGroup="ProjectValidation" ControlToValidate="txtClient" ErrorMessage="*" ForeColor="Red" Font-Size="1.5em"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtClient" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <span class="span-label">Datum početka</span>
                            <asp:RequiredFieldValidator ID="ValidateDate" runat="server" ValidationGroup="ProjectValidation" ControlToValidate="txtDateOfStart" ErrorMessage="*" ForeColor="Red" Font-Size="1.5em"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtDateOfStart" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <span class="span-label">Voditelj projekta</span>
                            <asp:RequiredFieldValidator ID="ValidateProjectLeader" runat="server" ValidationGroup="ProjectValidation" ControlToValidate="txtProjectLeader" ErrorMessage="*" ForeColor="Red" Font-Size="1.5em"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtProjectLeader" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <span class="span-label">Timovi na projektu</span>
                            <asp:RequiredFieldValidator ID="ValidateTeams" runat="server" ValidationGroup="ProjectValidation" ControlToValidate="txaTeams" ErrorMessage="*" ForeColor="Red" Font-Size="1.5em"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txaTeams" runat="server" TextMode="MultiLine" Rows="3" Columns="20" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="row">
                            <div class="col-6">
                                <asp:Button ID="btnUpdate" runat="server" Text="Ažuriraj projekt" OnClick="btnUpdate_Click" ValidationGroup="ProjectValidation" CssClass="btn btn-primary btn-update" />
                            </div>
                            <div class="col-6">
                                <asp:Button ID="btnAdd" runat="server" Text="Dodaj projekt" OnClick="btnAdd_Click" ValidationGroup="ProjectValidation" CssClass="btn btn-primary btn-add" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 col-md-12">
                    <asp:GridView ID="Projects" runat="server" AllowSorting="true" AutoGenerateColumns="false" CssClass="gridView">
                        <Columns>
                            <asp:BoundField DataField="IDProject" HeaderText="ID" ReadOnly="true" SortExpression="IDProject" HeaderStyle-CssClass="id-col" />
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
