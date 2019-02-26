% Author: Donggeun Yoo. (dgyoo@rcv.kaist.ac.kr)
function sendEmail( adrssFrom, pwdFrom, adrssTo, title, mssg, attchFpaths )    
    try
        % Gmail server supported only.
        setpref( 'Internet', 'SMTP_Server', 'smtp.gmail.com' );
        setpref( 'Internet', 'E_mail', adrssFrom );
        setpref( 'Internet', 'SMTP_Username', adrssFrom );
        setpref( 'Internet', 'SMTP_Password', pwdFrom );
        setpref( 'Internet', 'E_mail_Charset', 'SJIS' );
        props = java.lang.System.getProperties;
        props.setProperty( 'mail.smtp.auth', 'true' );
        props.setProperty( 'mail.smtp.socketFactory.class',  'javax.net.ssl.SSLSocketFactory' );
        props.setProperty( 'mail.smtp.socketFactory.port', '465' );
        if isempty( attchFpaths )
            sendmail( adrssTo, title, mssg );
        else
            sendmail( adrssTo, title, mssg, attchFpaths );
        end
    catch
        fprintf( 'Fail to send email.\n' );
    end;
end