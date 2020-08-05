# Monster Shop Extensions - Bulk Discount

**Context:**

This is the final project of Turing School Mod2. 
The base repo is a bare bones (non-styled) completed version of the previous group project, that we were asked to build upon for this assignment.

## Bulk Discount

[Original Project Spec README](https://github.com/turingschool-examples/monster_shop_final/blob/master/README.md)

#### Completion Criteria

1. Merchants need full CRUD functionality on bulk discounts, and will be accessed a link on the merchant's dashboard.
1. You will implement a percentage based discount: 
   - 5% discount on 20 or more items
1. A merchant can have multiple bulk discounts in the system.
1. When a user adds enough value or quantity of a single item to their cart, the bulk discount will automatically show up on the cart page.
1. A bulk discount from one merchant will only affect items from that merchant in the cart.
1. A bulk discount will only apply to items which exceed the minimum quantity specified in the bulk discount. (eg, a 5% off 5 items or more does not activate if a user is buying 1 quantity of 5 different items; if they raise the quantity of one item to 5, then the bulk discount is only applied to that one item, not all of the others as well)
1. When there is a conflict between two discounts, the greater of the two will be applied. 
1. Final discounted prices should appear on the orders show page.

[Brain Dump Gist](https://gist.github.com/gabichuelas/5cd33cac6c10d88650957a83d40839fc)

#### Mod 2 Learning Goals reflected:
- Database relationships and migrations
- Advanced ActiveRecord
- Software Testing

---

_Extensions from original README were not completed_
