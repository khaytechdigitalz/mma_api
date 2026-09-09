<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>{{ @$body['subject'] }}</title>
    <style type="text/css">
        body, table, td, a {
            -webkit-text-size-adjust: 100%;
            -ms-text-size-adjust: 100%;
        }
        table, td {
            mso-table-lspace: 0pt;
            mso-table-rspace: 0pt;
        }
        img {
            -ms-interpolation-mode: bicubic;
            border: 0;
            height: auto;
            line-height: 100%;
            outline: none;
            text-decoration: none;
        }
        table {
            border-collapse: collapse !important;
        }
        body {
            height: 100% !important;
            margin: 0 !important;
            padding: 0 !important;
            width: 100% !important;
            background-color: #f4f7fa;
        }
    </style>
</head>

<body style="margin: 0; padding: 0; background-color: #f4f7fa; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td align="center" style="padding: 40px 0 20px 0;">
                <img src="https://via.placeholder.com/160x45/0f172a/ffffff?text=YOUR+LOGO" alt="Company Logo"
                    width="160"
                    style="display: block; font-family: Arial, sans-serif; color: #1e293b; font-size: 24px; font-weight: bold;" />
            </td>
        </tr>
        <tr>
            <td align="center" style="padding: 0 10px 40px 10px;">
                <table border="0" cellpadding="0" cellspacing="0" width="100%"
                    style="max-width: 500px; background-color: #ffffff; border-radius: 32px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); border: 1px solid #eef2f6; overflow: hidden;">

                    <tr>
                        <td align="center" style="padding: 50px 40px 20px 40px;">
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td align="center" bgcolor="#fef2f2" style="border-radius: 50%; padding: 20px;">
                                        <img src="https://cdn-icons-png.flaticon.com/512/1828/1828843.png" width="50"
                                            height="50" alt="Declined" style="display: block;">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>

                    <tr>
                        <td align="center" style="padding: 10px 40px 10px 40px;">
                            <h1 style="margin: 0; color: #0f172a; font-size: 26px; font-weight: 800; line-height: 34px;">
                                Refund Declined
                            </h1>
                        </td>
                    </tr>

                    <tr>
                        <td align="center" style="padding: 0 40px 20px 40px; color: #64748b; font-size: 16px; line-height: 24px;">
                            Hello <strong>{{ @$body['user_name'] }}</strong>, we are writing to let you know that your refund request for Order <strong>#{{ @$body['order_no'] }}</strong> could not be approved.
                        </td>
                    </tr>

                    <tr>
                        <td align="center" style="padding: 0 40px 30px 40px;">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%" style="background-color: #fff5f5; border-radius: 16px; border: 1px solid #fed7d7; padding: 20px;">
                                <tr>
                                    <td style="color: #9b2c2c; font-size: 14px; line-height: 22px;">
                                        <strong>Refund Reference:</strong> {{ @$body['refund_no'] }}<br />
                                        <strong>Requested Amount:</strong> {{ @$body['amount'] }}<br />
                                        <strong>Reason for Rejection:</strong> {{ @$body['admin_notes'] }}
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>

                    <tr>
                        <td align="left" bgcolor="#f8fafc" style="padding: 25px 40px; border-top: 1px solid #f1f5f9;">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td style="color: #64748b; font-size: 13px; line-height: 20px;">
                                        <strong>Have concerns?</strong> If you feel this decision was made in error or have additional details to provide, please reach out to our <a href="#" style="color: #ef4444; text-decoration: none; font-weight: bold;">support team</a>.
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>

        <tr>
            <td align="center" style="padding: 0 10px 40px 10px;">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 500px;">
                    <tr>
                        <td align="center" style="padding: 20px 0 0 0; color: #94a3b8; font-size: 11px; line-height: 18px; text-transform: uppercase; letter-spacing: 2px;">
                            This is an automated message from <strong>Your Company</strong>.<br />
                            &copy; 2026 Tech City, USA.
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>