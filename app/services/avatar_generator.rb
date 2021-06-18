class AvatarGenerator
  MAX_SIZE = 5
  CONTENT_TYPES = %w[image/jpeg image/pjpeg image/png image/x-png]

  attr_accessor :errors

  def initialize(user, params)
    @user   = user
    @params = params
    @avatar = params[:avatar]
    @errors = []

    validate_avatar
  end

  def call
    @user.avatar.purge if @user.avatar.attached?

    @user.avatar.attach(
      io: process_image,
      filename: @user.username,
      content_type: @avatar.content_type
    )
  end

  private

  def process_image
    orig_width = @params[:original_width].to_i
    width      = @params[:height_width].to_i
    left       = @params[:width_offset].to_i
    top        = @params[:height_offset].to_i

    ImageProcessing::MiniMagick.
      source(@avatar.tempfile).
      resize_to_fit(orig_width, nil).
      crop("#{width}x#{width}+#{left}+#{top}!").
      convert("png").
      call
  end

  def validate_avatar
    if CONTENT_TYPES.exclude?(@avatar.content_type)
      @errors << I18n.t("users.show.invalid_format")
    end

    if @avatar.size.to_f > MAX_SIZE.megabytes
      @errors << I18n.t("users.avatar.max_size_warning", size: MAX_SIZE)
    end
  end
end
