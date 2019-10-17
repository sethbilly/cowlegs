module Api
  module V1
    class UserSerializer < Api::BaseSerializer
      attributes(
        :id,
        :slug,
        :email,
        :first_name,
        :last_name,
        :phone_number,
        :location,
        :gender,
        :region,
        :district,
        :zone_id,
        :type_of_id,
        :id_number,
        :picture,
        :date_of_birth,
        :role,
        :organizations,
        :created_at,
        :current_sign_in_at
      )

      has_many :commissions
      has_many :campaigns

      def organizations
        object.organizations.pluck(:id)
      end

      def commissions
        object.commissions.limit(10)
      end

      def location
        if object.location.class == String
          eval(object.location)
        elsif object.location.class == Hash
          object.location
        end
      end

    end
  end
end
