when CLIENTSSL_CLIENTCERT { 

    set error_string 0 

    # Check if there is at least one client cert     
    if {[SSL::cert count] > 0} { 
        # Check if there was no error in validating the client cert against LTM's server cert         
        if { [SSL::verify_result] == 0 }{ 
            # Exit this event in this iRule             
            return         
        } else {             
            set subject_dn [X509::subject [SSL::cert 0]]             
            set error_string [X509::verify_cert_error_string [SSL::verify_result]]             
            log local0. "SSL::verify_result = $error_string; Client-IP = [IP::client_addr]; Subject: $subject_dn; \n"
        }    
    } else {         
        set error_string "No client certificate provided"         
        log local0. "SSL::verify_result = $error_string; Client-IP = [IP::client_addr];"
    }     
} 