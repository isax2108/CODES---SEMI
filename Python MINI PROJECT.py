import datetime
import tkinter as tk
from tkinter import messagebox

# Define list of available locations
locations = [
    'Mumbai', 'Pune', 'Delhi', 'Bangalore', 'Hyderabad',
    'Chennai', 'Kolkata', 'Ahmedabad', 'Jaipur', 'Lucknow'
]

# Define tier prices
tier_prices = {
    1: 2000,  # First Tier
    2: 1200,   # Second Tier
    3: 400    # Sleeper Tier
}

# Define bidirectional route prices
route_prices = {
    frozenset(["Mumbai", "Pune"]): 400,
    frozenset(["Mumbai", "Delhi"]): 1800,
    frozenset(["Mumbai", "Bangalore"]): 1500,
    frozenset(["Mumbai", "Hyderabad"]): 1200,
    frozenset(["Mumbai", "Chennai"]): 1700,
    frozenset(["Mumbai", "Kolkata"]): 2000,
    frozenset(["Mumbai", "Ahmedabad"]): 600,
    frozenset(["Mumbai", "Jaipur"]): 1300,
    frozenset(["Mumbai", "Lucknow"]): 1600,
    frozenset(["Pune", "Delhi"]): 1700,
    frozenset(["Pune", "Bangalore"]): 1000,
    frozenset(["Pune", "Hyderabad"]): 900,
    frozenset(["Pune", "Chennai"]): 1100,
    frozenset(["Pune", "Kolkata"]): 1900,
    frozenset(["Pune", "Ahmedabad"]): 800,
    frozenset(["Pune", "Jaipur"]): 1200,
    frozenset(["Pune", "Lucknow"]): 1400,
    frozenset(["Delhi", "Bangalore"]): 2000,
    frozenset(["Delhi", "Hyderabad"]): 1600,
    frozenset(["Delhi", "Chennai"]): 1800,
    frozenset(["Delhi", "Kolkata"]): 1500,
    frozenset(["Delhi", "Ahmedabad"]): 900,
    frozenset(["Delhi", "Jaipur"]): 700,
    frozenset(["Delhi", "Lucknow"]): 600,
    frozenset(["Bangalore", "Hyderabad"]): 700,
    frozenset(["Bangalore", "Chennai"]): 500,
    frozenset(["Bangalore", "Kolkata"]): 1700,
    frozenset(["Bangalore", "Ahmedabad"]): 1600,
    frozenset(["Bangalore", "Jaipur"]): 1900,
    frozenset(["Bangalore", "Lucknow"]): 1800,
    frozenset(["Hyderabad", "Chennai"]): 800,
    frozenset(["Hyderabad", "Kolkata"]): 1500,
    frozenset(["Hyderabad", "Ahmedabad"]): 1400,
    frozenset(["Hyderabad", "Jaipur"]): 1600,
    frozenset(["Hyderabad", "Lucknow"]): 1300,
    frozenset(["Chennai", "Kolkata"]): 1600,
    frozenset(["Chennai", "Ahmedabad"]): 1800,
    frozenset(["Chennai", "Jaipur"]): 1700,
    frozenset(["Chennai", "Lucknow"]): 1900,
    frozenset(["Kolkata", "Ahmedabad"]): 2000,
    frozenset(["Kolkata", "Jaipur"]): 1800,
    frozenset(["Kolkata", "Lucknow"]): 1500,
    frozenset(["Ahmedabad", "Jaipur"]): 800,
    frozenset(["Ahmedabad", "Lucknow"]): 1000,
    frozenset(["Jaipur", "Lucknow"]): 700
}


# Function to display available locations
def display_locations():
    print("\nAvailable Locations:")
    for i, loc in enumerate(locations, 1):
        print(f"{i}. {loc}")


# Function to calculate total price based on tier, route, and number of travelers
def calculate_price(from_loc, to_loc, tier, travelers):
    route_key = frozenset([from_loc, to_loc])
    if route_key in route_prices:
        base_price = route_prices[route_key]
        return (base_price + tier_prices[tier]) * travelers
    else:
        print("Error: Route not available.")
        return None

def show_popup(ticket_number, name, phone_number, jdate, from_loc, to_loc, travelers):
    root = tk.Tk()
    root.withdraw()  # Hide the main window

    # Format the message in the desired order
    message = (
        f"Reservation Successful!\n\n"
        f"Name: {name}\n"
        f"Journey Date: {jdate}\n"
        f"From: {from_loc}\n"
        f"To: {to_loc}\n"
        f"Number of Travelers: {travelers}\n"
        f"Booking Number: {ticket_number}"
    )
    messagebox.showinfo("Booking Confirmation", message)
    root.destroy()

# Reservation Function
def make_reservation():
    print("\nTrain From?")
    display_locations()
    from_index = int(input("Enter your choice: ")) - 1

    print("\nTrain To?")
    display_locations()
    to_index = int(input("Enter your choice: ")) - 1

    # Check if departure and destination are the same
    if from_index == to_index:
        print("Error: 'FROM' and 'TO' destinations cannot be the same.")
        return

    from_loc = locations[from_index]
    to_loc = locations[to_index]

    # Journey date
    jdate = input("Enter journey date (DD-MM-YYYY): ")
    try:
        jdate_obj = datetime.datetime.strptime(jdate, "%d-%m-%Y")
    except ValueError:
        print("Invalid date format.")
        return

    print(f"Train from {from_loc} to {to_loc} leaves at 12 PM.")

    # Select tier
    print("\nChoose a tier:")
    print("1. First Tier (₹2000)")
    print("2. Second Tier (₹1200)")
    print("3. Sleeper Tier (₹400)")

    try:
        tier_choice = int(input("Enter tier number (1-3): "))
        if tier_choice not in tier_prices:
            print("Invalid tier choice.")
            return
    except ValueError:
        print("Invalid input for tier.")
        return

    # Number of travelers
    try:
        travelers = int(input("Number of travelers? "))
        if travelers < 1:
            print("Number of travelers must be at least 1.")
            return
    except ValueError:
        print("Invalid input for travelers.")
        return

    # Calculate total price
    total_price = calculate_price(from_loc, to_loc, tier_choice, travelers)
    if total_price is None:
        return
    print(f"Total price: ₹{total_price}")

    # Generate ticket number
    ticket_number = 10010 + 1000 * from_index + 100 * to_index
    name = input("Enter your name: ")
    phone_number = input("Enter your phone number: ")
    print(f"Ticket booked successfully! Your ticket number is {ticket_number}")
    show_popup(ticket_number, name,phone_number, jdate, from_loc, to_loc, travelers)

# Run the program
if __name__ == "__main__":
    make_reservation()
