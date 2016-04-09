EntryType.destroy_all
ActiveRecord::Base.connection.reset_pk_sequence!('entry_types')
KIND = %w(Bilet Karnet).freeze
10.times do
    EntryType.create!(
        kind: KIND.sample,
        kind_details: Faker::Lorem.sentence(3, true, 4),
        description: Faker::Lorem.paragraph,
        price: Faker::Number.decimal(2)
    )
end
p "Created #{EntryType.count} entry types"
