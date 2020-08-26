# Whenever a new client connects this will compute an 8 character hash based on the source IP and port.
# It then attempts to log how the connection flows through the F5, stamping all log lines with the hash
# to allow tracking through the logs.

when CLIENT_ACCEPTED {
    set HASH [string range [b64encode [CRYPTO::hash -alg sha1 [IP::client_addr][TCP::client_port]]] 0 8]
    log local0. "  $HASH: Client \"[IP::client_addr]:[TCP::client_port]\" connecting to\
                    \"[IP::local_addr]:[TCP::local_port]\" - connection accepted."
}

when CLIENT_CLOSED {
    log local0. "    $HASH: Client connection closed"
}

when SERVER_CONNECTED {
    log local0. " $HASH: Connected to server"
    log local0. " $HASH:   [serverside {IP::local_addr}]:[serverside {TCP::local_port}]\
    -> [IP::server_addr]:[serverside {TCP::remote_port}]"
}

when SERVER_CLOSED {
    log local0. "    $HASH: Server connection closed"
}


when LB_SELECTED {
    log local0. "      $HASH: Selected \"[LB::server]\""
}

when HTTP_REQUEST {
    log local0. "     $HASH: Request is \"[HTTP::request]\""
    foreach HEADNAME [HTTP::header names] {
        log local0. "     $HASH:   Request header \"$HEADNAME\" has value \"[HTTP::header value $HEADNAME]\""
    }
    log local0. "     $HASH: Persistence is \"[LB::persist]\""
}

when HTTP_RESPONSE {
    log local0. "    $HASH: Response code is \"[HTTP::status]\""
    log local0. "    $HASH: Response headers are \"[HTTP::header names]\""
    foreach HEADNAME [HTTP::header names] {
        log local0. "    $HASH:   Response header \"$HEADNAME\" has value \"[HTTP::header value $HEADNAME]\""
    }
}

when HTTP_REQUEST_SEND {
    log local0. "$HASH: HTTP Request Sent"
}

# the HTTP_REJECT event was added in BIGIP-12.0.0 so this one may cause errors on anything earlier
when HTTP_REJECT {
    log local0. "      $HASH: HTTP Aborted: [HTTP::reject_reason]"
}