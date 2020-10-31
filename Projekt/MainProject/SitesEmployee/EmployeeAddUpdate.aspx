<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeAddUpdate.aspx.cs" Inherits="MainProject.SitesEmployee.EmployeeAddUpdate" %>

<%@ Register Src="~/Components/HomeBar.ascx" TagPrefix="uc1" TagName="HomeBar" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Postavke zaposlenika</title>
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
                        <h1 class="page-title">Postavke djelatnika</h1>
                        <div class="form-group">
                            <span class="span-label">Ime i prezime</span>
                            <asp:RequiredFieldValidator ID="ValidateFullName" runat="server" ValidationGroup="EmployeeValidation" ControlToValidate="txtFullName" ErrorMessage="*" ForeColor="Red" Font-Size="1.5em"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <span class="span-label">Email</span>
                            <asp:RequiredFieldValidator ID="ValidateEmail" runat="server" ValidationGroup="EmployeeValidation" ControlToValidate="txtEmail" ErrorMessage="*" ForeColor="Red" Font-Size="1.5em"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <span class="span-label">Datum zaposlenja</span>
                            <asp:RequiredFieldValidator ID="ValidateDate" runat="server" ValidationGroup="EmployeeValidation" ControlToValidate="txtDate" ErrorMessage="*" ForeColor="Red" Font-Size="1.5em"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtDate" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <span class="span-label">Vrsta zaposlenika</span>
                            <asp:RequiredFieldValidator ID="ValidateType" runat="server" ValidationGroup="EmployeeValidation" ControlToValidate="txtType" ErrorMessage="*" ForeColor="Red" Font-Size="1.5em"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtType" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <span class="span-label">Naziv tima</span>
                            <asp:TextBox ID="txtTeam" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="row">
                            <div class="col-6">
                                <asp:Button ID="btnUpdate" runat="server" Text="Ažuriraj djelatnika" OnClick="btnUpdate_Click" ValidationGroup="EmployeeValidation" CssClass="btn btn-primary btn-update" />
                            </div>
                            <div class="col-6">
                                <asp:Button ID="btnAdd" runat="server" Text="Dodaj djelatnika" OnClick="btnAdd_Click" ValidationGroup="EmployeeValidation" CssClass="btn btn-primary btn-add" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 col-md-12">
                    <asp:GridView ID="Employees" runat="server" AutoGenerateColumns="false" CssClass="gridView">
                        <Columns>
                            <asp:BoundField DataField="IDWorker" HeaderText="ID" ReadOnly="true" SortExpression="IDWorker" HeaderStyle-CssClass="id-col" />
                            <asp:BoundField DataField="FullName" HeaderText="Ime i prezime" ReadOnly="true" SortExpression="FullName" />
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
