
import argparse

## CLI INTERFACE ##
parser = argparse.ArgumentParser(description="the thing this whole thing does")

# positional, mandatory
parser.add_argument("echo", help="echo the string you use here")

# optional; make flag
parser.add_argument("-v", "--verbosity",
                    help="increase output verbosity",
                    action="store_true")

# parameter validation
parser.add_argument("-p", "--print",
                    help="print 1|2",
                    type=int, choices=[0,1,2])

# count; -t vs -tt
parser.add_argument("-t", "--typer",
                    help="typing",
                    action="count")

# mutually exclusive group
group = argparse.ArgumentParser()
group = parser.add_mutually_exclusive_group()
group.add_argument("-k", "--okay", action="store_true")
group.add_argument("-q", "--quiet", action="store_true")


args = parser.parse_args()

## LOGIC ## 
if args.verbosity:
    print("verbosity turned on")

if args.typer == 1:
    print("number 1")
elif args.typer == 2:
    print("number 2 number 2")
