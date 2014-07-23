FactoryGirl.define do
  factory :cat do
    sequence(:name) { |n| "Cat #{n}" }
    bio 'Bio'
    breed 'Breed'
    catchphrase 'Catchphrase'
  end
end
