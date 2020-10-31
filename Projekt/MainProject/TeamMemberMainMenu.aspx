<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TeamMemberMainMenu.aspx.cs" Inherits="MainProject.TeamMemberMainMenu" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Početna stranica</title>
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <link href="Style/TeamMemberMainMenu.css" rel="stylesheet" />
    <script src="Scripts/jquery-3.5.0.js"></script>
    <script src="Scripts/bootstrap.js"></script>
    <script src="Scripts/popper.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid padding">
            <div class="row greeting-row">
                <div class="col-12 greeting">
                    <h1 runat="server" id="h1Greeting">Pozdrav, ljudov!</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-6 col-md-12 column">
                    <div class="row">
                        <div class="panel panel-default panel-custom">
                            <div class="panel-body">
                                Basic panel example
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-6">
                            <asp:Button Text="Start" runat="server" CssClass="btn btn-custom start-button" />
                        </div>
                        <div class="col-6">
                            <asp:Button Text="Stop" runat="server" CssClass="btn btn-custom stop-button" />
                        </div>
                    </div>
                </div>
                <div class="col-lg-6 col-md-12 column">
                    <asp:Table ID="tbProjects" runat="server"
                        BackColor="Transparent"
                        ForeColor="Black"
                        CellSpacing="5"
                        CssClass="table" CellPadding="1">
                        <asp:TableRow ID="trSickLeave" runat="server" BackColor="White" CssClass="tablerow">
                            <asp:TableCell>Bolovanje</asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow ID="trVacation" runat="server" BackColor="White" CssClass="tablerow">
                            <asp:TableCell>Godišnji odmor</asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow ID="trPause" runat="server" BackColor="White" CssClass="tablerow">
                            <asp:TableCell>Pauza</asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow ID="trProjectOne" runat="server" BackColor="White" CssClass="tablerow">
                            <asp:TableCell>Projekt #1</asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow ID="trProjectTwo" runat="server" BackColor="White" CssClass="tablerow">
                            <asp:TableCell>Projekt #2</asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow ID="trProjectThree" runat="server" BackColor="White" CssClass="tablerow">
                            <asp:TableCell>Projekt #3</asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow ID="trProjectFour" runat="server" BackColor="White" CssClass="tablerow">
                            <asp:TableCell>Projekt #4</asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow ID="trProjectFive" runat="server" BackColor="White" CssClass="tablerow">
                            <asp:TableCell>Projekt #5</asp:TableCell>
                        </asp:TableRow>
                        <asp:TableRow ID="trProjectSix" runat="server" BackColor="White" CssClass="tablerow">
                            <asp:TableCell>Projekt #6</asp:TableCell>
                        </asp:TableRow>
                    </asp:Table>
                </div>
            </div>
        </div>
        <footer>
            <hr />
            <p>
                &copy;App footer,
                <script>document.write(new Date().getFullYear()); </script>
            </p>
        </footer>
    </form>
</body>
</html>
