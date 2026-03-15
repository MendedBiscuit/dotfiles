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
        "What is the cardinality of the power set of a set with 3 elements?" "Fundamental group of RP^2?"
        "First Betti number of the torus?" "Is the Sorgenfrey line paracompact? (yes/no)"
        "Are eigenvalues of a unitary matrix always of absolute value 1? (yes/no)" "Hausdorff dimension of the middle-thirds Cantor set?"
        "Galois group of x^3-2 over Q?" "Is every compact Hausdorff space normal? (yes/no)"
        "Euler characteristic of the Klein bottle?" "Expected number of points in a Lebesgue measure 0 set for a Poisson point process?"
        "Dimension of an n-simplex?" "Is the tensor product of two non-zero vector spaces ever zero? (yes/no)"
        "Does every continuous map from S^2 to R^2 map some antipodal pair to the same point? (yes/no)"
        "Is the algebraic closure of a field algebraically closed? (yes/no)"
        "Does the spectral theorem apply to all normal operators on a finite complex inner product space? (yes/no)"
        "What is the maximum degree of a vertex in the 1-skeleton of a standard n-simplex?"
        "What is the Euler characteristic of a sphere?" "Is every metric space paracompact? (yes/no)"
        "Are all Hilbert spaces reflexive? (yes/no)" "What is the topological dimension of R^n?"
        "Is the fundamental group of a simply connected space trivial? (yes/no)"
        "Is the Euler characteristic of a compact manifold a topological invariant? (yes/no)"
        "What is the degree of the map z -> z^n on S^1?" "Does SVGD rely on an RKHS? (yes/no)"
        "Is the rank of the nth homology group of an n-sphere 1? (yes/no)" "What is the Euler characteristic of RP^2?"
        "Is the fundamental group of a figure-eight space the free group on two generators? (yes/no)"
        "Are persistence diagrams stable under the bottleneck distance? (yes/no)"
        "Does the Cech complex satisfy the Nerve theorem for convex covers? (yes/no)"
        "Is the Wasserstein distance an optimal transport metric? (yes/no)"
        "Is the 0th Betti number equal to the number of connected components? (yes/no)"
        "Is a Mobius strip orientable? (yes/no)" "Does the SVGD update direction minimize the KL divergence? (yes/no)"
        "Dimension of the first homology group of a genus-g surface?"
        "Is the Vietoris-Rips complex always a subcomplex of the Cech complex for the same radius? (yes/no)"
        "Is the space of persistence diagrams a complete metric space? (yes/no)"
        "Is the alpha complex a subcomplex of the Delaunay triangulation? (yes/no)"
        "Is the Rips complex a flag complex? (yes/no)" "Does the Wasserstein-2 metric satisfy the triangle inequality? (yes/no)"
        "Is every persistent module over a field decomposable into intervals? (yes/no)"
        "Is the rank of a unitary matrix always full? (yes/no)"
    )

    ANSWERS=(
        "24" "yes" "n+1" "yes" "7" "yes" "True" "yes" "1" "yes" "yes" "2" "True" "4" "yes" "yes" "0" "9" "yes" "2" "yes" "True" "G" "2" "no"
        "no" "no" "no" "no" "no" "no" "12" "3" "no" "2" "False" "no" "no" "4" "yes" "no" "2" "yes" "no" "no" "4" "True" "even" "yes" "8"
        "Z/2Z" "2" "yes" "yes" "ln(2)/ln(3)" "S_3" "yes" "0" "0" "n" "no" "yes" "yes" "yes" "n" "2" "yes" "yes" "n" "yes"
        "yes" "n" "yes" "yes" "1" "yes" "yes" "yes" "yes" "yes" "no" "yes" "2g" "no" "yes" "yes" "yes" "yes" "yes" "yes"
    )

    INDEX=$(( RANDOM % ${#QUESTIONS[@]} ))
    SELECTED_Q=${QUESTIONS[$INDEX]}
    EXPECTED_A=${ANSWERS[$INDEX]}

    echo "--- UNLOCK CHALLENGE ---"
    echo "$SELECTED_Q"
    read -r USER_ANSWER

    if [ "$USER_ANSWER" == "$EXPECTED_A" ]; then
        TARGET_SENTENCE="I am writing this sitting in the bedroom sink. In a rut."
        echo "Correct. Now, type this sentence exactly to proceed:"
        echo "\"$TARGET_SENTENCE\""
        
        read -r TYPED_SENTENCE
        if [ "$TYPED_SENTENCE" == "$TARGET_SENTENCE" ]; then
            echo "Sentence verified."
            for i in {180..1}; do
                printf "\rTime remaining: %02d:%02d " $((i/60)) $((i%60))
                sleep 1
            done
            echo -e "\nReflection period complete."
            
            sudo mv /etc/hosts /etc/hosts.blocked
            sudo mv /etc/hosts.backup /etc/hosts 2>/dev/null
            send_notification "Focus Mode: OFF" "Relax mode unlocked."
            echo "Relax mode enabled."
        else
            echo "Typing error. Choice rejected. Get back to work."
        fi
    else
        echo "Incorrect answer. Focus harder."
    fi
fi
