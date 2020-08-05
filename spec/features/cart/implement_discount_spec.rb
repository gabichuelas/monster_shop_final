RSpec.describe 'As a visitor' do
  describe 'If I add an item to my cart, and the quantity in the cart matches the item_minimum for any discount offered by that item\'s merchant' do

    before :each do
      #
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)

      @employee = User.create!(name: 'Gaby Mendez', address: '1422 NE 20th Ave.', city: 'Gainesville', state: 'FL', zip: 32609, role: 1, email: 'employee@hotmail.com', password: 'employee', merchant_id: @megan.id)
      @user = User.create!(name: 'Alex Kio', address: '1204 NE 10th Ave.', city: 'Gainesville', state: 'FL', zip: 32601, email: 'user@hotmail.com', password: 'user')

      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 15 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @fig = @megan.items.create!(name: 'Fig Jam', description: "I'm delicious!", price: 5, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 22 )

      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 6 )

      @twenty_ten = Discount.create!(name: 'Twenty on Ten', item_minimum: 10, percent: 20, merchant_id: @megan.id)
      @five_five = Discount.create!(name: 'Five on Five', item_minimum: 5, percent: 5, merchant_id: @megan.id)
      @ten_on_four = Discount.create!(name: 'Ten on Four', item_minimum: 4, percent: 10, merchant_id: @megan.id)
      @fifteen_on_four = Discount.create!(name: 'Fifteen on Four', item_minimum: 4, percent: 15, merchant_id: @megan.id)

      visit item_path(@ogre)
      click_button 'Add to Cart'
      visit item_path(@hippo)
      click_button 'Add to Cart'
      visit item_path(@fig)
      click_button 'Add to Cart'
    end

    it 'then the discount is applied automatically and seen on the cart show page' do
      #
      visit "/cart"

      within "#item-#{@fig.id}" do
        expect(page).to have_content("Quantity: 1")
        4.times do
          click_on 'More of This!'
        end
        expect(page).to have_content("Quantity: 5")
        expect(page).to have_content("Subtotal: $23.75")
        expect(page).to have_content("Discount Applied: #{@five_five.percent}%")
      end
    end

    it 'discounts are merchant specific and only apply to merchant\'s items' do
      #
      visit "/cart"

      within "#item-#{@fig.id}" do
        expect(page).to have_content("Quantity: 1")
        4.times do
          click_on 'More of This!'
        end
        expect(page).to have_content("Quantity: 5")
        expect(page).to have_content("Subtotal: $23.75")
        expect(page).to have_content("Discount Applied: #{@five_five.percent}%")
      end

      within "#item-#{@hippo.id}" do
        expect(page).to have_content("Quantity: 1")
        4.times do
          click_on 'More of This!'
        end
        expect(page).to have_content("Quantity: 5")
        expect(page).to have_content("Subtotal: $250.00")
        expect(page).to_not have_content("Discount Applied: #{@five_five.percent}%")
      end
    end

    it 'If two discounts have the same item_minimum, the better discount is chosen' do

      visit "/cart"

      within "#item-#{@fig.id}" do
        expect(page).to have_content("Quantity: 1")
        3.times do
          click_on 'More of This!'
        end
        expect(page).to have_content("Quantity: 4")
        expect(page).to have_content("Subtotal: $17.00")
        expect(page).to have_content("Discount Applied: #{@fifteen_on_four.percent}%")
      end
    end
  end
end
