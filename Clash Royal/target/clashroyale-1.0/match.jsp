<%-- 
    Document   : chat
    Created on : Jun 24, 2018, 6:08:41 PM
    Author     : TGMaster
--%>

<%@page import="Config.Config, Entity.Player" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>IU Gaming Tour</title>
        <%Player p = (Player) session.getAttribute("player");%>

        <script type="text/javascript">
            var socketUrl = "ws://localhost:8080/room";
            var userId = "<%=player.getId()%>";
            var userName = "<%=player.getUsername()%>";
        </script>
        <link rel="icon" href="assets/images/iugt-black.png">
        <link rel="stylesheet" href="assets/bootstrap/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/match.css">
        <link rel="stylesheet" href="assets/fonts/font-awesome.min.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Aldrich">
        <link rel="stylesheet" href="assets/css/styles.css">

    </head>
    <body onunload="return closeSocket()">
        <section>
            <nav class="navbar navbar-default navbar-fixed-top navigation-clean-button"
                 style="background-color:rgba(0, 0, 0, 0.5);color:rgb(255,255,255);">
                <div class="container" style="width: 100% !important;">
                    <div class="navbar-header">
                        <a class="navbar-brand" href="index.jsp" style="font-family:Aldrich, sans-serif;font-size:18px;">
                            <img class="img-responsive" src="assets/images/iugt-white.png"
                                 style="width:50px;height:50px;margin-top:-15px;">IU GAMING TOUR
                        </a>
                        <button class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navcol-1">
                            <span class="sr-only">Toggle navigation</span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                    </div>
                    <div class="collapse navbar-collapse" id="navcol-1">
                        <% if (isLogin) {%>
                        <ul class="nav navbar-nav navbar-right">

                            <li class="dropdown">
                                <a class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false" href="#"
                                   style="color:rgb(255,255,255);font-size:14px;">
                                    <img src="assets/images/default-avatar.png" class="dropdown-image"
                                         style="width:50px;height:50px;margin-top:-15px;">
                                    <strong><%=player.getUsername()%>
                                    </strong>
                                    <span class="caret" style="color:white;"></span>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-right" role="menu">
                                    <li role="presentation"><a class="text-uppercase" href="#"><i class="fa fa-user-circle-o" style="font-size:15px;"></i> <strong>PROFILE</strong></a></li>
                                    <li role="presentation"><a class="text-uppercase" href="user?action=logout"><i class="fa fa-sign-out" style="font-size:15px;"></i> <strong>LOG OUT</strong></a></li>
                                </ul>
                            </li>
                        </ul>
                        <%} else {%>
                        <ul class="nav navbar-nav navbar-right" style="margin-right: 50px">
                            <li class="dropdown">
                                <a class="btn btn-default action-button dropdown-toggle" href="#" data-toggle="dropdown" id="login"><i class="fa fa-sign-in" style="font-size:15px;"></i> <strong>LOG IN</strong></a>
                                <div class="dropdown-menu" style="padding: 15px; padding-bottom: 10px;">
                                    <form action="user" class="form-horizontal"  method="post" accept-charset="UTF-8">
                                        <input id="username" class="form-control login" type="text" name="username" placeholder="Username..." />
                                        <input id="password" class="form-control login" type="password" name="password" placeholder="Password..."/>
                                        <button class="btn btn-primary" type="submit" name="action" value="login">LOGIN</button>
                                    </form>
                                </div>
                            </li>
                        </ul>
                        <%}%>
                    </div>
                </div>
            </nav>
        </section>
        <section style="padding-top: 70px;">
            <form id="teamList">
                <div class="btn-group btn-control" role="group" id="btnGroup">
                    <button class="btn btn-default visible-sm-block visible-xs-block" id="switchBtn" onclick="swapTeam()" type="button">
                        <i class="fa fa-exchange" style="font-size:17px;"></i> <strong>SWITCH</strong></strong>
                    </button>

                    <button class="btn btn-default btn-leave"><i class="fa fa-times" style="font-size:17px;"></i>
                        <strong>LEAVE</strong>
                    </button>
                </div>

                <div class="row" id="upper-container">
                    <!--Team List-->
                    <div class="teamview">
                        <!--CT Team-->
                        <div class="col-md-3 hidden-sm hidden-xs"><img class="img-responsive" src="assets/images/GR.png"
                                                                       onclick="imgSwapCT(userId)"></div>
                        <div class="col-md-2 col-sm-4 col-xs-4 team-info">
                            <div id="TeamCT"></div>
                        </div>
                        <!--End of CT Team-->

                        <!--Match Info-->
                        <div class="col-md-2 col-sm-4 col-xs-4 match-info">
                            <div class="server-info">
                                <img src="assets/images/versus.png" class="img-responsive" alt="VS"/>
                                <div id="onlyOwner"></div>
                                <div class="server-connect">
                                    <div id="server"></div>
                                </div>
                            </div>
                        </div>
                        <!--End of Match Info-->

                        <!--T Team-->
                        <div class="col-md-2 col-sm-4 col-xs-4 team-info">
                            <div id="TeamT"></div>
                        </div>
                        <div class="col-md-3 hidden-sm hidden-xs"><img class="img-responsive" src="assets/images/BL.png"
                                                                       onclick="imgSwapT(userId)"></div>
                        <!--End of T Team-->
                    </div>
                </div>
            </form>
            <!--Chat Room-->
            <div class="row" style="padding-top: 50px">
                <div class="col-md-3 col-sm-2 hidden-xs"></div>
                <div class="form-group col-md-6 col-sm-8 col-xs-12">
                    <textarea class="form-control rounded-0" id="textAreaMessage" rows="15" readonly></textarea>
                    <div class="inner-addon right-addon">
                        <input type="text" class="form-control" id="textMessage" placeholder="Message..."/>
                    </div>

                </div>
                <div class="col-md-3 col-sm-2 hidden-xs"></div>
            </div>
            <!--End of Chat Room-->

        </section>

        <script src="assets/js/jquery-3.2.1.js"></script>
        <script src="assets/bootstrap/js/bootstrap.min.js"></script>
        <script src="assets/js/match.min.js"></script>
        <script type="text/javascript">start();</script>

    </body>
</html>
