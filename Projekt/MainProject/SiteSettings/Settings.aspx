<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="MainProject.SiteSettings.Settings" %>

<%@ Register Src="~/Components/HomeBar.ascx" TagPrefix="uc1" TagName="HomeBar" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Postavke</title>
    <link href="../Style/Settings.css" rel="stylesheet" />
    <link href="../Style/HomeLink.css" rel="stylesheet" />
    <link href="../Content/bootstrap.css" rel="stylesheet" />
    <script src="../Scripts/jquery-3.5.0.js"></script>
    <script src="../Scripts/bootstrap.js"></script>
    <script src="../Scripts/popper.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <uc1:HomeBar runat="server" ID="HomeBar" />
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <h1 class="main-title">Postavke profila</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <div class="form-group">
                        <span class="span-label">Ime</span>
                        <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <span class="span-label">Prezime</span>
                        <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <span class="span-label">Email</span>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <span class="span-label">Datum zaposlenja</span>
                        <asp:TextBox ID="txtDate" runat="server" ReadOnly="true" CssClass="form-control" />
                    </div>
                    <div class="form-group">
                        <span class="span-label">Tip zaposlenika</span>
                        <asp:TextBox ID="txtType" runat="server" ReadOnly="true" CssClass="form-control" />
                    </div>
                    <asp:Button ID="Update" Text="Spremi" runat="server" OnClick="Update_Click" CssClass="btn btn-warning btn-custom"/>
                    <asp:Button ID="LogOut" Text="Odjavi se" runat="server" OnClick="LogOut_Click" CssClass="btn btn-danger btn-custom btn-logout"/>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
