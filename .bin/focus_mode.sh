#!/bin/bash

REAL_USER=$(logname 2>/dev/null || echo $USER)

send_notification() {
    if [ -n "$DISPLAY" ]; then
        sudo -u "$REAL_USER" DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u "$REAL_USER")/bus notify-send "$1" "$2" 2>/dev/null
    fi
}

if [ "$1" == "work" ]; then
    sudo cp /etc/hosts.blocked /etc/hosts
    pkill gammastep 2>/dev/null
    send_notification "Focus Mode: ON" "Distractions blocked."
    echo "Work mode enabled. Go get it."

elif [ "$1" == "relax" ]; then
    QUESTIONS=(
        "What is the order of S_4?" "Is every cyclic group abelian? (yes/no)" "Dimension of P_n(R)?" 
        "If |G| is prime, is G cyclic? (yes/no)" "Characteristic of Z/7Z?" "Is every field an integral domain? (yes/no)" 
        "True or False: Every subgroup of an abelian group is normal." "Is every ED a PID? (yes/no)" 
        "Determinant of I_3?" "Is the kernel of a ring homomorphism an ideal? (yes/no)" "Is Z a UFD? (yes/no)" 
        "Dimension of C over R?" "True or False: A finite integral domain is a field." "Size of (Z/5Z)*?" 
        "Is the ideal (x) prime in Z[x]? (yes/no)" "Is every PID a UFD? (yes/no)" "Characteristic of a field containing Q?" 
        "Number of elements in GF(9)?" "Is Q(sqrt(2)) a vector space over Q? (yes/no)" "Degree of extension [C:R]?" 
        "Is every alternating group A_n simple for n >= 5? (yes/no)" "True or False: Every finite group of prime order is simple." 
        "What is the center of a commutative group G?" "What is the index of A_n in S_n?" "Is Z a field? (yes/no)" 
        "Is S_3 abelian? (yes/no)" "Is every subgroup of S_3 normal? (yes/no)" "Is Z[x] a PID? (yes/no)" 
        "Is every UFD a PID? (yes/no)" "Does every field have characteristic 0? (yes/no)" "Is the union of two subspaces always a subspace? (yes/no)" 
        "What is the order of the group A_4?" "How many Sylow 2-subgroups does S_3 have?" "Is the ring 2Z a field? (yes/no)" 
        "What is the trace of I_2?" "True or False: Every linear map is an isomorphism." "Is x^2 + 1 reducible over R? (yes/no)" 
        "Is the ring of 2x2 matrices over R commutative? (yes/no)" "What is the dimension of M_2x2(R)?" 
        "Is the intersection of two ideals an ideal? (yes/no)" "Is every group of order 4 cyclic? (yes/no)" 
        "What is the characteristic of GF(8)?" "Is the product of two units a unit? (yes/no)" 
        "Does a non-zero ring always have a multiplicative identity? (yes/no)" "Is Q a finite field? (yes/no)" 
        "What is the degree of the extension [Q(sqrt(2), sqrt(3)):Q]?" "True or False: Every group of order 15 is cyclic." 
        "What is the parity of a 3-cycle in S_n?" "Is the polynomial ring F[x] an ED if F is a field? (yes/no)" 
        "What is the cardinality of the power set of a set with 3 elements?"
    )
    
    ANSWERS=(
        "24" "yes" "n+1" "yes" "7" "yes" "True" "yes" "1" "yes" "yes" "2" "True" "4" "yes" "yes" "0" "9" "yes" "2" "yes" "True" "G" "2" "no" 
        "no" "no" "no" "no" "no" "no" "12" "3" "no" "2" "False" "no" "no" "4" "yes" "no" "2" "yes" "no" "no" "4" "True" "even" "yes" "8"
    )

    INDEX=$(( RANDOM % ${#QUESTIONS[@]} ))
    SELECTED_Q=${QUESTIONS[$INDEX]}
    EXPECTED_A=${ANSWERS[$INDEX]}

    echo "--- UNLOCK ---"
    echo "$SELECTED_Q"
    read -p "Answer: " answer

    if [ "${answer,,}" != "${EXPECTED_A,,}" ]; then
        echo "Incorrect. Focus harder."
        exit 1
    fi

    SENTENCE="I write this sitting in the kitchen sink."
    echo -e "\nType the following:"
    echo "$SENTENCE"
    read -p "> " input

    if [ "$input" != "$SENTENCE" ]; then
        echo "Err"
        exit 1
    fi

    echo -e "\n Cooldown..."
    for i in {180..1}; do
        printf "%d " $i
        sleep 1
    done
    echo -e "\n"

    sudo cp /etc/hosts.open /etc/hosts
    send_notification "Focus Mode: OFF" "Distractions unblocked."
    echo "off"
fi
