def adjuntar(cad):
    return str(cad.split("\t"))

def main():
    consultas = []
    table = input().strip()
    n = input()
    consultas.append(adjuntar(n))
    
    while n!="":
        n = input()
        consultas.append(adjuntar(n))

    print(consultas)
    del(consultas[-1])
    for i in consultas:
        i = i.replace("[","")
        i = i.replace("]","")
        cad = i
        cad.strip()
        print("INSERT INTO",table,"VALUES("+cad+");")
main()
